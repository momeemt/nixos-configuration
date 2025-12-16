{config, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "${config.xdg.stateHome}/zsh/history";
      save = 10000;
      share = true;
      size = 10000;
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

      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      unset __HM_SESS_VARS_SOURCED
      source ${config.xdg.configHome}/zsh/.zshenv
    '';
  };
}
