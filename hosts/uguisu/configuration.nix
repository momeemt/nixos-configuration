{ pkgs, ... }:
{
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

  nix = {
    package = pkgs.nix;
  };

  services = {
    nix-daemon = {
      enable = true;
    };
  };

  programs.zsh.enable = true;
  users.users.momeemt = {
    name = "momeemt";
    home = "/Users/momeemt";
    shell = pkgs.zsh;
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleTemperatureUnit = "Celsius";
      };
    };
  };
}
