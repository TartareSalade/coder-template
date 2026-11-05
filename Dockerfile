
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-venv \
        python3-pip \
        curl \
        ca-certificates \
        git \
        openssh-client \
        jq \
        sudo \
        bash && \
    rm -rf /var/lib/apt/lists/*

#avoid to use root user
RUN useradd -m -s /bin/bash coder && mkdir -p /home/coder && chown -R coder:coder /home/coder

USER coder
WORKDIR /home/coder

# uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/home/coder/.local/bin:${PATH}"

CMD ["bash"]
