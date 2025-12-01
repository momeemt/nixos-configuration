{pkgs, ...}: {
  imports = [
    ./wallpapers.nix
    ../../profiles/sops
    ../../profiles/hosts/fonts
    ../../profiles/hosts/services/aerospace
    ../../profiles/hosts/system
    ../../profiles/site/services/set-wallpapers
  ];

  environment = {
    systemPackages = with pkgs; [
      tart
    ];

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enableCompletion
    pathsToLink = [
      "/share/bash-completion"
    ];

    shells = with pkgs; [
      bash
      zsh
    ];
  };

  # Using DetermineSystems/nix-installer to install Nix
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  users.users.momeemt = {
    name = "momeemt";
    home = "/Users/momeemt";
    shell = pkgs.zsh;
  };

  system = {
    primaryUser = "momeemt";
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleTemperatureUnit = "Celsius";
      };
    };
  };

  networking = {
    computerName = "uguisu";
    hostName = "uguisu";
    localHostName = "uguisu";
  };
}
