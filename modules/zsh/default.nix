{
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
      share = true;
      size = 10000;
    };

    shellAliases = {
      ls = "eza";
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
    '';
  };
}
