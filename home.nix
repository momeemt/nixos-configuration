{ config, pkgs, ... }:
let inherit (builtins) getEnv;
in {
  home = {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "22.11";
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  programs.home-manager.enable = true;
}
