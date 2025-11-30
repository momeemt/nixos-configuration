{
  imports = [
    ./debug.nix
    ./font.nix
    ./hints.nix
    ./scrolling.nix
    ./terminal.nix
    ./window.nix
  ];

  programs.alacritty.settings = {
    env = {
      TERM = "xterm-256color";
      COLORTERM = "truecolor";
    };
    mouse = {
      hide_when_typing = true;
    };
  };
}
