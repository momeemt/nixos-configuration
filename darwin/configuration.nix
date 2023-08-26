{ pkgs, ... }:
{
  imports = [
    ./yabai.nix
  ];

  services = {
    nix-daemon = {
      enable = true;
    };

    skhd = {
      enable = true;
    };
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
