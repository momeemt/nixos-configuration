{pkgs, ...}: {
  imports = [
    ./dock.nix
    ./networking.nix
    ./yabai.nix
    ./skhd.nix
    ../../modules/sops
    ../../modules/hosts/fonts
  ];

  environment = {
    systemPackages = with pkgs; [
      skhd
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
    stateVersion = 6;
    primaryUser = "momeemt";
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleTemperatureUnit = "Celsius";
      };
    };
  };
}
