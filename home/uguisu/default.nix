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
    ../../modules/tmux
    ../../modules/zsh
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
}
