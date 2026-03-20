FROM codercom/enterprise-base:ubuntu

USER root

# Install fish shell
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      fish \
      curl \
      wget \
      unzip \
      jq \
      openssh-client \
      ca-certificates \
      gnupg && \
    rm -rf /var/lib/apt/lists/*

# Install Go
ARG GO_VERSION=1.24.1
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Docker CLI
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Install Claude Code (via npm)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    rm -rf /var/lib/apt/lists/*

# Install OpenAI Codex CLI
RUN npm install -g @openai/codex

# Install Zed remote server
RUN curl -fsSL https://zed.dev/install.sh | sh

# Set fish as default shell for coder user
RUN chsh -s /usr/bin/fish coder

USER coder

# Setup Go paths for coder user
ENV GOPATH="/home/coder/go"
ENV PATH="/home/coder/go/bin:/usr/local/go/bin:${PATH}"
