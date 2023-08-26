{ pkgs, ... }:
{
  services = {
    nix-daemon = {
      enable = true;
    };

    yabai = {
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
