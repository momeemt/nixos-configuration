{
  programs.tmux-nix = {
    enable = true;
    prefix = "C-a";
    keymaps = {
      pane = {
        left.key = "h";
        right.key = "l";
        up.key = "k";
        down.key = "j";
      };
      resize = {
        left = {
          key = "H";
          amount = 5;
        };
        right = {
          key = "L";
          amount = 5;
        };
        up = {
          key = "K";
          amount = 5;
        };
        down = {
          key = "J";
          amount = 5;
        };
      };
    };
  };
}
