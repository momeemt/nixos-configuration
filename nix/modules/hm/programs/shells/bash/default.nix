{
  pkgs,
  lib,
  config,
  ...
} @ args: let
  systemConfig = args.systemConfig or null;
  shellAliases = import ../common/aliases.nix {inherit config lib systemConfig;};
in {
  programs.bash = {
    inherit shellAliases;

    enable = true;
    enableCompletion = true;
    # VTE integration not needed for Alacritty
    enableVteIntegration = false;
    package = pkgs.bash;

    initExtra = ''
      bind -r "\e[A"
      bind -r "\e[B"
      bind -r "\e[C"
      bind -r "\e[D"
    '';

    historyControl = ["ignoreboth"];
    historyFile = "${config.xdg.stateHome}/bash/history";
    # https://man7.org/linux/man-pages/man1/bash.1.html
    # > Non-numeric values and numeric values less than zero inhibit truncation.
    historyFileSize = -1;
    historySize = 100000;
    historyIgnore = [
      "ls"
      "cd"
      "exit"
      "rm"
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enableCompletion
  assertions =
    lib.optional (systemConfig != null)
    {
      assertion = lib.elem "/share/bash-completion" (systemConfig.environment.pathsToLink or []);
      message = ''
        When `programs.bash.enableCompletion = true`,
        system `environment.pathsToLink` must include "/share/bash-completion".
      '';
    };
}
