{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
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
    initExtra = builtins.readFile ../zsh/zshrc;
    loginExtra = ''
      FPATH=${../zsh/functions}:$FPATH
      export FPATH

      . ${../zsh/completion.zsh}
    '';
  };
}
