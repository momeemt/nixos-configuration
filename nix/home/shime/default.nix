{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/nixvim
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
    ../../modules/hm/nix
    ../../modules/hm/editorconfig
    ../../modules/hm/programs/only-cli.nix
    ../../modules/hm/sops
    ../../modules/hm/wakatime
    ../../modules/site/home
  ];

  site.home.username = "momeemt";
}
