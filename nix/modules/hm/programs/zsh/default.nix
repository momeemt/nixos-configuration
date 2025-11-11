{config, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "${config.xdg.stateHome}/zsh/history";
      save = 10000;
      share = true;
      size = 10000;
    };

    shellAliases = {
      ls = "eza";
      bash = "/run/current-system/sw/bin/bash";
      zsh = "/run/current-system/sw/bin/zsh";
    };

    completionInit = ''
      typeset -U fpath
      fpath=(${./completions} ${./functions} $fpath)
      autoload -U compinit
      compinit -i
    '';

    initContent = ''
      typeset -U path
      bindkey -r "^[[A"
      bindkey -r "^[[B"
      bindkey -r "^[[C"
      bindkey -r "^[[D"

      autoload -Uz nr

      unset __HM_SESS_VARS_SOURCED
      source ${config.xdg.stateHome}/nix/profiles/home-manager/home-path/etc/profile.d/hm-session-vars.sh
    '';
  };
}
