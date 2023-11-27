{ pkgs, ... }:
let
  tmux-sensible = import ./tmux/tmux-sensible.nix {
    inherit (pkgs) tmuxPlugins fetchFromGitHub;
  };
  tmux-window-name = import ./tmux/tmux-window-name.nix {
    inherit (pkgs) tmuxPlugins fetchFromGitHub python311 python311Packages tmux ps lib;
  };
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;
    secureSocket = false;
    sensibleOnTop = false;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      set-environment -g PATH "${pkgs.tmux}/bin/:$PATH"
    '' + builtins.readFile ../tmux/tmux.conf;
    plugins = [
      tmux-sensible
      tmux-window-name
    ];
  };
}
