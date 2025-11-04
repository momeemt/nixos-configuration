{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/alacritty
    ../../modules/direnv
    ../../modules/git
    ../../modules/nixvim
    ../../modules/starship
    ../../modules/tmux
    ../../modules/zsh
    ../../modules/hm/accounts/calendar
    ../../modules/hm/sops
    ../../modules/site/env
  ];

  home = let
    systemPackages = import ../../system/packages {inherit pkgs;};
    ncp = import ../../packages/ncp/default.nix {inherit pkgs;};
  in {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "25.05";
    packages = with pkgs;
      [
        ghq
        ncp
        brewCasks.anki
      ]
      ++ systemPackages;
  };

  programs.git = {
    signing = {
      key = "ACB54F0CBC6AA7C6";
      signByDefault = true;
    };
  };

  programs.home-manager.enable = true;

  site.env.extraSessionPath = [
    "${config.home.homeDirectory}/Library/Application Support/JetBrains/Toolbox/scripts"
  ];
}
