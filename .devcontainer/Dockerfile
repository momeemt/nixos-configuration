FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8  \
  USER=example \
  HOME=/home/example

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    locales \
    sudo \
    xz-utils \
  && locale-gen en_US.UTF-8 ja_JP.UTF-8 \
  && update-locale LANG=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash "${USER}" \
  && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
  && chmod 440 /etc/sudoers.d/${USER}

USER ${USER}
WORKDIR ${HOME}

SHELL ["/bin/bash", "-lc"]

RUN sudo mkdir -p /etc/nix \
  && echo 'sandbox = false' | sudo tee -a /etc/nix/nix.conf \
  # see https://github.com/NixOS/nix/issues/5258
  && echo 'filter-syscalls = false' | sudo tee -a /etc/nix/nix.conf \
  && sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

COPY --chown=${USER}:${USER} . ${HOME}/config
WORKDIR ${HOME}/config

RUN rm -f "${HOME}/.profile" "${HOME}/.bashrc" \
  && nix run \
    --extra-experimental-features 'nix-command flakes' \
    --impure \
    ".#homeConfigurations.${USER}.activationPackage" \
  && echo '. "$HOME/.nix-profile/etc/profile.d/nix.sh"' | sudo tee -a /etc/profile >/dev/null

WORKDIR ${HOME}
CMD ["/bin/bash", "-lc", "exec zsh -l"]
