
terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

data "coder_provisioner" "me" {}
data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

resource "coder_agent" "main" {
  arch = data.coder_provisioner.me.arch
  os   = "linux"

  startup_script = <<-EOT
    #!/bin/bash
    set -e

    echo "Python workspace ready"
    python3 --version
    uv --version
    git --version
  EOT

  env = {
    GIT_AUTHOR_NAME = coalesce(
      data.coder_workspace_owner.me.full_name,
      data.coder_workspace_owner.me.name
    )
    GIT_AUTHOR_EMAIL = data.coder_workspace_owner.me.email

    GIT_COMMITTER_NAME = coalesce(
      data.coder_workspace_owner.me.full_name,
      data.coder_workspace_owner.me.name
    )
    GIT_COMMITTER_EMAIL = data.coder_workspace_owner.me.email
  }
}

resource "docker_image" "workspace" {
  name = "coder-python-dev:latest"

  build {
    context = "${path.module}/build"
  }

  triggers = {
    dir_sha1 = sha1(join("", [
      for f in fileset(path.module, "build/*") :
      filesha1("${path.module}/${f}")
    ]))
  }
}

resource "docker_volume" "home" {
  name = "coder-${data.coder_workspace.me.id}-home"

  lifecycle {
    ignore_changes = all
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count

  name = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}"

  image    = docker_image.workspace.image_id
  hostname = data.coder_workspace.me.name

  entrypoint = [
    "sh",
    "-c",
    replace(
      coder_agent.main.init_script,
      "/localhost|127\\.0\\.0\\.1/",
      "host.docker.internal"
    )
  ]

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}"
  ]

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/home/coder"
    volume_name    = docker_volume.home.name
    read_only      = false
  }
}
