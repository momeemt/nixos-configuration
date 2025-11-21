{pkgs, ...}: {
  programs.alacritty.settings.terminal = {
    shell = {
      program = "${pkgs.zsh}/bin/zsh";
      args = [
        "-l"
        "-c"
        ''${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux new -s main''
      ];
    };
    osc52 = "CopyPaste";
  };
}
