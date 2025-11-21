{pkgs, ...}: {
  imports = [
    ./settings
  ];

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
  };
}
