{
  config,
  lib,
  ...
} @ args: let
  systemConfig = args.systemConfig or null;
  nix-bin = "/run/current-system/sw/bin";
  h = config.home.homeDirectory;
  inherit (config.xdg) configHome;
in {
  home.shellAliases =
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
      man = "batman";
      watch = "batwatch";
      nix-collect-garbage = "nh clean all";
    }
    // lib.optionalAttrs (systemConfig != null) {
      bash = "${nix-bin}/bash";
      zsh = "${nix-bin}/zsh";
    };
}
