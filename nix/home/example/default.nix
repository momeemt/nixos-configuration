{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ../../modules/nixvim
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
    ../../modules/hm/nix
    ../../modules/hm/editorconfig
    ../../modules/hm/programs/only-cli.nix
    ../../modules/site/home
  ];

  nix.package = pkgs.nix;
  site.home.username = "example";
}
