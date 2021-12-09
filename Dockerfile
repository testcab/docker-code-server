FROM testcab/yay
LABEL maintainer="test.cab <code-server@test.cab>"

# Install code-server
RUN yay -Syyu --noconfirm code-server

# Add and configure code-server user
USER root
ARG user=coder
RUN useradd -m $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$user > /dev/null \
  && curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5/fixuid-0.5-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - \
  && chown root:root /usr/local/bin/fixuid \
  && chmod 4755 /usr/local/bin/fixuid \
  && mkdir -p /etc/fixuid \
  && printf "user: $user\ngroup: $user\n" > /etc/fixuid/config.yml
USER $user
WORKDIR /home/$user
ENTRYPOINT ["fixuid", "-q", "code-server", "--bind-addr", "0.0.0.0:8080"]

# Install tools and programming languages
RUN yay -Syyu --noconfirm \
  # Cloud Tools
  aws-cli azure-cli google-cloud-sdk \
  # Editors
  nano vim \
  # Programming Languages
  dotnet-sdk aspnet-targeting-pack \
  go \
  groovy \
  jdk-openjdk openjdk-src \
  nodejs npm yarn \
  powershell-bin \
  python python-pip \
  # Tools
  ansible \
  bash-completion shellcheck \
  docker docker-compose \
  rmate \
  terraform terragrunt
