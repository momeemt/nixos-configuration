{ pkgs, ... }:
{
  programs.zsh = {
    autocd = true;
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "vicmd";

    initExtra = builtins.readFile ../zsh/zshrc;
    envExtra = builtins.readFile ../zsh/zshenv;
    logoutExtra = builtins.readFile ../zsh/zlogout;
    profileExtra = builtins.readFile ../zsh/zprofile;
  };
}
