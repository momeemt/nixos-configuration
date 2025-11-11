{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ../../modules/nixvim
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
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
