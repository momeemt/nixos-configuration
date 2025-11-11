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
    ../../modules/hm/accounts/contact
    ../../modules/hm/accounts/email
    ../../modules/hm/nix
    ../../modules/hm/programs
    ../../modules/hm/sops
    ../../modules/site/home
    ../../modules/site/programs/nimble
  ];

  site = {
    home = {
      username = "momeemt";
      groups.darwinCasks = true;
      extraDarwinCasks = with pkgs.brewCasks; [
        anki
      ];
      extraSessionPath = [
        "${config.home.homeDirectory}/Library/Application Support/JetBrains/Toolbox/scripts"
      ];
    };
    programs = {
      nimble = {
        enable = true;
        nimbleDir = "${config.xdg.configHome}/nimble/";
      };
    };
  };

  programs = {
    git = {
      signing = {
        key = "ACB54F0CBC6AA7C6";
        signByDefault = true;
      };
    };

    aerc = {
      enable = true;
      extraConfig = {
        general = {
          # Allow accounts.conf (0444) from nix-store
          "unsafe-accounts-conf" = true;
        };
      };
    };

    home-manager.enable = true;
    lieer.enable = true;
    notmuch.enable = true;
    khal.enable = true;
    vdirsyncer.enable = true;
    khard.enable = true;
  };

  services.vdirsyncer.enable = true;
}
