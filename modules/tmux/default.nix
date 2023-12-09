{ pkgs, lib, ... }:
let
  tmux-battery = import ./tmux/tmux-battery.nix {
    inherit (pkgs) tmuxPlugins fetchFromGitHub lib;
  };
  tmux-fzf = import ./tmux/tmux-fzf.nix {
    inherit (pkgs) tmuxPlugins fetchFromGitHub bash gnused fzf pstree lib;
  };
  tmux-sensible = import ./tmux/tmux-sensible.nix {
    inherit (pkgs) tmuxPlugins fetchFromGitHub;
  };
  tmux-window-name = import ./tmux/tmux-window-name.nix {
    inherit (pkgs) tmuxPlugins fetchFromGitHub python311 python311Packages tmux ps lib;
  };
  tmux-plugins = [
    tmux-battery
    tmux-fzf
    tmux-sensible
    tmux-window-name
  ];
  runShellAll = plugins: lib.concatStringsSep "\n" (map
    (plugin:
      "run-shell ${plugin}/share/tmux-plugins/${plugin.pluginName}/${plugin.rtpFilePath}"
    )
    plugins);
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
    '' + builtins.readFile ../tmux/tmux.conf
    + runShellAll tmux-plugins;
  };
}
