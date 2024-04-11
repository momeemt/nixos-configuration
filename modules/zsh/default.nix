{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    completionInit = "autoload -U compinit && compinit -i";
    defaultKeymap = "emacs";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = "$HOME/.zsh_history";
      save = 10000;
      share = true;
      size = 10000;
    };
    shellAliases = {
      nd = "nix develop -c $SHELL";
      ns = "nix-shell --command \"zsh\"";
      ls = "eza";
    };
    initExtra = builtins.readFile ./zshrc;
    profileExtra = builtins.readFile ./zprofile;
    loginExtra = ''
      FPATH=${./functions}:$FPATH
      export FPATH

      . ${./completion.zsh}
    '';
  };
}
