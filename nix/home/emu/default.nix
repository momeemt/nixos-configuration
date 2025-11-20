{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/nixvim
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
    ../../modules/hm/nix
    ../../modules/hm/programs
    ../../modules/hm/sops
    ../../modules/hm/wakatime
    ../../modules/site/home
  ];

  site.home = {
    username = "momeemt";
    groups.linuxDesktop = true;
    extraPackages = with pkgs; [
      quartus-prime-lite
    ];
  };

  programs.home-manager.enable = true;
}
