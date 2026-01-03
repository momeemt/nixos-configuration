{pkgs, ...}: {
  imports = [
    ./wallpapers.nix
    ../../profiles/sops
    ../../profiles/hosts
    ../../profiles/hosts/services/aerospace
    ../../profiles/hosts/services/karabiner-elements
  ];

  system.primaryUser = "momeemt";

  homebrew = {
    enable = true;
    masApps = {
      # Pages = 409201541;
      # Numbers = 409203825;
      # Keynote = 409183694;
      # Goodnotes = 1444383602;
      Habitify = 1111447047;
      Sorted = 1306893526;
      Tailscale = 1475387142;
      "Notify for Spotify" = 1517312650;
      LINE = 539883307;
      Canva = 897446215;
    };
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

  networking = {
    computerName = "uguisu";
    hostName = "uguisu";
    localHostName = "uguisu";
  };
}
