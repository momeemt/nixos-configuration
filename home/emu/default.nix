{ pkgs, ... }: {
  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neofetch
    neovim
  ];

  programs.zsh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Mutsuha Asada";
    userEmail = "me@momee.mt";
  };
}
