# dotfiles
the personal dotfiles

## Construction

| Category | Name |
| ---- | ---- |
| OS | macOS 13.0, NixOS 23.05 |
| Environment Manager | [home-manager](https://github.com/nix-community/home-manager), nix-darwin |
| Languages | Nix, zsh, VimScript, Lua |
| Shell | zsh |
| Multiplexer | tmux |
| Editor | neovim |
| VCS | git |
| Terminal | Aracritty |
| Customizable Prompt | starship |
| Window Manager | yabai |

## Installation

### home-manager

```sh
$ nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```

## License
- MIT OR Apache 2.0

## Author
- [Mutsuha Asada](https://github.com/momeemt)
