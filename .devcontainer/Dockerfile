# Pull base image.
FROM ubuntu:22.04
LABEL TauriTools.version="0.1"
LABEL vendor="github.com/RomanoViolet/Minimalist_Tauri_with_MonacoEdtor"
LABEL TauriTools.release-date="2024-June-22"
LABEL TauriTools.version.is-production="No"

ARG USERNAME=dockeruser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
# Install Core components.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt --fix-broken install && \
  apt-get -qqy upgrade && \
  apt-get -y install --no-install-recommends apt-utils dialog 2>&1 && \
  apt-get install -y build-essential && \
  apt-get install -y cmake && \
  apt-get install -y software-properties-common && \
  apt-get install -y sudo && \
  apt-get install -qqy libz-dev && \
  apt-get install -qqy curl unzip && \
  apt-get install -qqy gnupg && \
  apt-get install -qqy net-tools && \
  apt-get install -qqy wget && \
  apt-get install -qqy pkg-config && \
  apt-get install -qqy libssl-dev  && \
  apt-get install -qqy openssl && \
  apt-get install -qqy bash && \
  apt-get install -qqy git git-lfs && \
  apt-get install -qqy npm && npm install -g live-server &&\
  apt-get install -qqy curl && \
  apt-get install -qqy apt-transport-https && \
  apt-get install -qqy locales && \
  apt-get install -qqy x11-apps && \
  apt-get install -qqy powerline && \
  apt-get install -qqy file

# Dependencies for Tauri app
RUN \
  apt-get update && apt-get install -qqy --no-install-recommends \
  libappindicator3-dev \
  libgtk-3-dev \
  librsvg2-dev \
  libssl-dev \
  libwebkit2gtk-4.0-dev \
  libjavascriptcoregtk-4.0-dev \
  javascriptcoregtk-4.0 \
  webkit2gtk-4.0

RUN \
  apt-get --fix-broken install -qqy

RUN \
  apt-get install -qqy --no-install-recommends \
  libayatana-appindicator3-dev

RUN \
  apt-get install -qqy --no-install-recommends \
  libsoup2.4-common \
  libsoup2.4-dev

RUN \
  apt-get --fix-broken install -qqy
#
#
# NodeJs
RUN \
  apt-get update && \
  rm -rf /etc/apt/sources.list.d/nodesource.list && \
  apt-get --fix-broken install -qqy && \
  apt-get update -qqy && \
  apt-get purge --auto-remove -qqy nodejs && \
  yes | dpkg --remove --force-remove-reinstreq libnode-dev && \
  yes | dpkg --remove --force-remove-reinstreq libnode72:amd64 && \
  apt-get install -qqy ca-certificates gnupg && \
  mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update -qqy && \
  apt-get install nodejs -y

#
# PNPM
RUN \
  npm install -g pnpm
#
# 
#
# Setup locales
RUN \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8 && \
  #
  # Add non-admin user
  groupadd --gid $USER_GID $USERNAME && \
  useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME && \
  #
  # Make sure that all file in /home/dockeruser are owned by dockeruser
  #
  chown -R dockeruser /home/dockeruser

# Add default home for the non-admin user
WORKDIR /home/dockeruser
ADD --chown=dockeruser Configurations/.bashrc /home/dockeruser/.bashrc


ENV LANG en_US.UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DISPLAY :0
# Do the following as an ordinary user
USER dockeruser

# Rust components
RUN \
  curl -sS https://sh.rustup.rs -sSf | sh -s -- -y && \
  export PATH="/home/${USERNAME}/.cargo/bin:$PATH" && \
  echo "export PATH=\"/home/${USERNAME}/.cargo/bin:$PATH\"" >> /home/${USERNAME}/.bashrc && \
  rustup component add clippy


USER dockeruser
RUN \
  chmod +x /home/${USERNAME}/.bashrc && \
  PATH=/home/${USERNAME}/.cargo/bin:$PATH && \
  cargo install cargo-watch && \
  cargo install cargo-llvm-cov && \
  cargo install grcov && \
  cargo install cargo-checkmate && \
  cargo install cargo-unused-features && \
  cargo install cargo-bloat && \
  rustup component add llvm-tools-preview


# Cleanup
USER root
RUN \
  apt -y autoremove && \
  apt-get purge -y --auto-remove xz-utils && \
  apt-get purge -y --auto-remove python3-pip && \
  apt-get purge -y --auto-remove apt-transport-https && \
  apt autoremove -y && \
  apt-get clean -y


# Define default command.
CMD ["/bin/bash"]
