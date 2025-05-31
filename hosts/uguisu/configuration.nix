{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./dock.nix
    ./networking.nix
    ./yabai.nix
    ./skhd.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      skhd
    ];
  };

  # Using DetermineSystems/nix-installer to install Nix
  nix.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "copilot.vim"
    ];

  programs.zsh.enable = true;
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
