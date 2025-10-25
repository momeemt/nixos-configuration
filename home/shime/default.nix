{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/alacritty
    ../../modules/direnv
    ../../modules/git
    inputs.nixvim.homeManagerModules.nixvim
    ../../modules/nixvim
    # ../../modules/neovim
    ../../modules/starship
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
    # ../../modules/tmux
    ../../modules/vscode
    ../../modules/zsh
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/home/momeemt";
    stateVersion = "25.05";
    packages = with pkgs;
      [
        usbutils
        (import ../../packages/ncp {inherit pkgs;})
      ]
      ++ import ../../system/packages {inherit pkgs;};
  };

  programs.home-manager.enable = true;
}
