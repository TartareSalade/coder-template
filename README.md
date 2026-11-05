# Coder Templates

A collection of self-hosted development environment templates for [Coder](https://coder.com), powered by Docker and Terraform.

**Coder Instance:** https://coder.sbkr.fr/

This project is primarily intended to provide a **personal development environment accessible from work**, allowing me to work on side projects without installing development tools or dependencies on my work computer.

The goal is to provide **reproducible, isolated, and ready-to-use development environments** with preconfigured tools and persistent storage.

## Available Templates

| Template | Stack | Description |
|----------|-------|-------------|
| [python-dev](./python-dev) | Python 3, uv, Git, SSH, jq | Python development environment with modern dependency management |

## Features

- **Self-hosted** : Run workspaces on my own Docker infrastructure.
- **Reproducible** : Environments defined using Terraform and Dockerfiles.
- **Persistent** : Docker volumes preserve workspace files across restarts.
- **Remote development** : Access personal projects from any computer through Coder.
- **No local setup** : Keep development tools and dependencies off the work computer.
- **Extensible** : Easily customize templates or add new development stacks.

## Project Structure

```text
coder-templates/
├── python-dev/
│   ├── main.tf
│   └── build/
│       └── Dockerfile
└── README.md
```

## Getting Started

1. Access the self-hosted Coder instance at [coder.sbkr.fr](https://coder.sbkr.fr/).
2. Import the desired template into Coder.
3. Create a workspace using the imported template.
4. Connect to the workspace and start coding.

## Requirements

- A running Coder instance
- Docker Engine accessible to the Coder provisioner
- Terraform providers for Coder and Docker

