{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../profiles/nixvim
    ../../profiles/hm/accounts/calendar
    ../../profiles/hm/accounts/contact
    ../../profiles/hm/accounts/email
    ../../profiles/hm/editorconfig
    ../../profiles/hm/homebrew
    ../../profiles/hm/nix
    ../../profiles/hm/programs
    ../../profiles/hm/programs/ssh
    ../../profiles/hm/programs/tmux
    ../../profiles/hm/services
    ../../profiles/hm/sops
    ../../profiles/hm/wakatime
    ../../profiles/site/home
    ../../profiles/site/programs/nimble
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

    wget.enable = true;

    aerc = {
      enable = true;
      extraConfig = {
        general = {
          # Allow accounts.conf (0444) from nix-store
          "unsafe-accounts-conf" = true;
        };
      };
    };
    lieer.enable = true;
    notmuch.enable = true;
    khal.enable = true;
    vdirsyncer.enable = true;
    khard.enable = true;
  };

  services.vdirsyncer.enable = true;
}
