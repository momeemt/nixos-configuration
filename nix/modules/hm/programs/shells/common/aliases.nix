{
  config,
  lib,
  systemConfig,
}: let
  nix-bin = "/run/current-system/sw/bin";
  h = config.home.homeDirectory;
  inherit (config.xdg) configHome;
in
  {
    ls = "eza";
    clocg = "cloc --vcs=git";
    clocgi = "cloc --vcs=git --exclude-list-file=.clocignore";
    bashrc = "source ${h}/.bashrc";
    zshrc = "source ${configHome}/zsh/.zshrc";
    back = "cd $OLDPWD";
    cd = "z";
    cat = "bat";
    diff = "batdiff";
    rg = "batgrep";
    # it destroys command_not_found_*
    # grep = "batgrep";
    man = "batman";
    watch = "batwatch";
  }
  // lib.optionalAttrs (systemConfig != null) {
    bash = "${nix-bin}/bash";
    zsh = "${nix-bin}/zsh";
  }
