<div align="center">

# ❄️ config

English | <a href="./README_JA.md">日本語</a> <br /> <br />
<img src="../assets/screenshot.png" style="width: 400" /> <br />

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![CI](https://github.com/momeemt/config/actions/workflows/ci.yaml/badge.svg)](https://github.com/momeemt/config/actions/workflows/ci.yaml)
[![Image](https://github.com/momeemt/config/actions/workflows/image.yaml/badge.svg)](https://github.com/momeemt/config/actions/workflows/image.yaml)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/momeemt/config)

</div>

<br />

This repository contains a set of configurations for declaratively managing
systems, user environments, infrastructure, and multiple nodes.

## Applying the configuration

> [!WARNING]
> If you want to try this config, it is recommended to use it inside a Docker
> container as described in the [Get Started](#get-started) section.\
> These configurations heavily depend on personal information of the
> [author](https://github.com/momeemt), such as user names, paths, and
> [credentials](../secrets), and cannot be applied to your environment as-is.\
> However, configuration for tools and systems is factored out into modules. If
> you have sufficient knowledge of Nix, you can fork this repository, delete
> unnecessary files, update configuration values, and then apply it on your own
> responsibility.

To apply these configurations, you need to have
[Nix](https://github.com/NixOS/nix) installed.\
Please install Nix using one of the following methods:

- [nix-installer](https://github.com/DeterminateSystems/nix-installer)
  (recommended)
- [Nix Download](https://nixos.org/download/)

The following operating systems are supported:

- [macOS Tahoe](https://www.apple.com/jp/os/macos/)
- [NixOS 25.11](https://nixos.org/download/)

### First-time setup

First, clone this repository:

```sh
git clone https://github.com/momeemt/config

# If gh is available
gh repo clone momeemt/config

# If ghq is available
ghq get momeemt/config
```

Next, run the following script to apply the configuration.

```sh
./assets/scripts/apply.sh
```

### Subsequent updates

Once you enter the devShell, you can use [just](https://github.com/casey/just),
a task runner tool.\
From the second time onward, you can apply the configuration by running:

```sh
just apply
```

## Why Nix/NixOS?

A build system that always produces bit-for-bit identical artifacts on any
environment when given the same inputs (source code, build manifests, etc.) is
said to provide [reproducible builds](https://reproducible-builds.org/).\
[Nix](https://nixos.org/) is one of the build systems that enable reproducible
builds.

Therefore, a properly pinned Nix configuration can be rebuilt with high
reproducibility even as time passes.\
It also makes it easy to share the configuration in this repository or other
users’ configurations written in Nix.

By using [home-manager](https://github.com/nix-community/home-manager), you can
manage user-space configuration with Nix, and by using
[NixOS](https://nixos.org/download) or
[nix-darwin](https://github.com/nix-darwin/nix-darwin), you can manage system
configuration with Nix as well.

![Repository size/freshness map](https://repology.org/graph/map_repo_size_fresh.svg)

The official package repository [nixpkgs](https://github.com/NixOS/nixpkgs)
provided by Nix offers
[more than 120,000 packages](https://search.nixos.org/packages) as of November
2025.\
You can also use it purely as a convenient package manager without using it for
system configuration.\
If you are interested, refer to the following resources:

- [Nix Tutorials](https://nix.dev/tutorials/)
- [Nix Reference Manual](https://nix.dev/manual/nix/2.24/)

## Get Started

You can try part of this repository’s configuration in a virtualized
environment.

### Using Docker

The Docker image defined in `.devcontainer/Dockerfile` is
[published](https://github.com/momeemt/config/pkgs/container/config) on GitHub
Container Registry (GHCR).

> [!WARNING]
> When a stable configuration is released, it will be merged into the main
> branch.\
> Since no release has been made yet, please use the `unstable` tag for the time
> being.

```sh
# HEAD of the main branch
docker pull ghcr.io/momeemt/config:latest

# HEAD of the develop branch
docker pull ghcr.io/momeemt/config:unstable
```

You can also use [Development Containers](https://containers.dev/) to access the
environment inside the container:

```sh
devcontainer up --workspace-folder .
```

## Documentation

Documentation for the configuration is available at the following link:

> [!WARNING]
> The documentation is currently under construction and incomplete.

[https://config.momee.mt](https://config.momee.mt)

## Development

In a typical workflow, you can enter the development environment using
[nix-direnv](https://github.com/nix-community/nix-direnv):

```sh
echo "use flake" > .envrc
direnv allow
```

If you want to enter an environment that `import`s a NixOS module downloaded
locally as a git submodule, modify `.envrc` as follows before applying it. For
example:

```sh
cat <<EOF > .envrc
use flake . --override-input tmux-nix path:./nix/flakes/tmux-nix
EOF
direnv allow
```

You can also generate environment definition files using just:

```sh
just env
```

## Templates

You can use Nix flake templates from this repository.\
For example, the following command generates a `flake.nix` for a Rust project:

```sh
nix flake init --template "github:momeemt/config#rust"
```

## Feedback

😌 If you have suggestions or improvements, feel free to open an issue:

[https://github.com/momeemt/config/issues](https://github.com/momeemt/config/issues)

## License

Unless otherwise noted, the source code and resources in this repository are
licensed under
[Apache-2.0](https://licenses.opensource.jp/Apache-2.0/Apache-2.0.html).\
You are free to use, copy, modify, and redistribute the contents of this
repository, including for commercial purposes, as long as you retain the
copyright notice, include the license text, and clearly indicate any changes.

However, different licenses may apply in the following cases:

1. If a file contains an explicit license notice, that notice takes precedence.
2. If a subdirectory contains a LICENSE file, the license described there
   applies to the files under that directory.

This license applies only to the extent permitted in the jurisdiction where the
user resides.

## References

My configuration is based on the following users’ dotfiles and configuration
files:

- Nix configurations
  - [ryota-ka/dotfiles](https://github.com/ryota-ka/dotfiles)
  - [natsukium/dotfiles](https://github.com/natsukium/dotfiles)
  - [glassesneo/dotfiles](https://github.com/glassesneo/dotfiles)
  - [misumisumi/nixos-desktop-config](https://github.com/misumisumi/nixos-desktop-config)
  - [takeokunn/nixos-configuration](https://github.com/takeokunn/nixos-configuration)
- dotfiles
  - [wasabi315/dotfiles](https://github.com/wasabi315/dotfiles)
- Kubernetes
  - [walnuts1018/infra](https://github.com/walnuts1018/infra)
