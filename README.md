# dotfiles

## home-manager

```sh
$ nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```
