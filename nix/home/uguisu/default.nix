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
    ../../modules/hm/programs/bash
    ../../modules/hm/sops
    ../../modules/site/env
    ../../modules/site/packages
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "25.05";
  };
  
  site.packages = {
    enable = true;
    groups.darwinCasks = true;
    extraDarwinCasks = with pkgs.brewCasks; [
      anki
    ];
  };

  programs.git = {
    signing = {
      key = "ACB54F0CBC6AA7C6";
      signByDefault = true;
    };
  };

  programs.home-manager.enable = true;
  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        # Allow accounts.conf (0444) from nix-store
        "unsafe-accounts-conf" = true;
      };
    };
  };
  programs.lieer.enable = true;
  programs.notmuch.enable = true;
  programs.khal.enable = true;
  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;
  programs.khard.enable = true;

  site.env.extraSessionPath = [
    "${config.home.homeDirectory}/Library/Application Support/JetBrains/Toolbox/scripts"
  ];
}
