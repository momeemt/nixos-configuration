{inputs, ...}: {
  imports = [
    ../../modules/alacritty
    ../../modules/direnv
    ../../modules/git
    inputs.nixvim.homeManagerModules.nixvim
    ../../modules/nixvim
    ../../modules/starship
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
    ../../modules/vscode
    ../../modules/zsh
    ../../modules/hm/nix
    ../../modules/hm/programs
    ../../modules/site/home
  ];

  site.home = {
    username = "momeemt";
    groups.linuxDesktop = true;
  };

  programs.home-manager.enable = true;
}
