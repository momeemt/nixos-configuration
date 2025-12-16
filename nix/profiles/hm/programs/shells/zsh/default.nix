{
  pkgs,
  config,
  lib,
  ...
} @ args: let
  systemConfig = args.systemConfig or null;
in {
  imports = [
    ./autosuggestion
    ./history
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = false;
    package = pkgs.zsh;

    # plugin managers
    antidote.enable = false;
    oh-my-zsh.enable = false;
    prezto.enable = false;
    zplug.enable = false;

    autocd = false;
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";
    syntaxHighlighting.enable = true;

    cdpath = [
      "${config.xdg.dataHome}/ghq/github.com"
      "${config.xdg.dataHome}/ghq/github.com/momeemt"
    ];

    dirHashes = {
      github = "${config.xdg.dataHome}/ghq/github.com";
      momeemt = "${config.xdg.dataHome}/ghq/github.com/momeemt";
    };

    completionInit = ''
      typeset -U fpath
      fpath=(${./completions} ${./functions} $fpath)
      autoload -U compinit
      compinit -i
    '';

    profileExtra = ''
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';

    initContent = ''
      typeset -U path
      bindkey -r "^[[A"
      bindkey -r "^[[B"
      bindkey -r "^[[C"
      bindkey -r "^[[D"

      autoload -Uz nr mkcd
    '';
  };

  assertions = lib.optional (systemConfig != null) {
    assertion = lib.elem "/share/zsh" (systemConfig.environment.pathsToLink or []);
    message = ''
      When `programs.zsh.enableCompletion = true`,
      system `environment.pathsToLink` must include "/share/zsh".
    '';
  };
}
