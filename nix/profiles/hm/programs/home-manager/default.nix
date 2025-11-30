{
  config,
  lib,
  ...
}: {
  programs.home-manager = {
    enable = true;
    path = lib.mkForce "${config.xdg.configHome}/nixpkgs/home-manager";
  };
}
