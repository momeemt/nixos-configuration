{
  lib,
  systemConfig,
}: let
  nix-bin = "/run/current-system/sw/bin";
in
  {
    ls = "eza";
    clocg = "cloc --vcs=git";
    clocgi = "cloc --vcs=git --exclude-list-file=.clockignore";
  }
  // lib.optionalAttrs (systemConfig != null) {
    bash = "${nix-bin}/bash";
    zsh = "${nix-bin}/zsh";
  }
