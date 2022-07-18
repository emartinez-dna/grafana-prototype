# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.238.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# install docker CLI by directly downloading the binaries, without also installing the docker engine.
ENV DOCKERVERSION=20.10.17
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

# Set up apt in order to apt-get install docker-compose.
RUN apt-get update
RUN apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker compose
RUN apt-get install docker-compose -y

# install inotifywait for the file watcher
RUN apt-get install -y inotify-tools

# install jsonnet
RUN apt-get install -y jsonnet

# install 
RUN apt-get install parallel -y