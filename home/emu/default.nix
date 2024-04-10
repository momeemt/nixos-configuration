{ pkgs, ... }: {
  imports = [
    ../../modules/neovim
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gh
    neofetch
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
