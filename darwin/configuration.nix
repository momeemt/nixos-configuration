{ pkgs, ... }:
{
  imports = [
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

  networking = {
    computerName = "uguisu";
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];
    hostName = "uguisu";
    knownNetworkServices = [
      "USB 10/100/1000 LAN"
      "USB 10/100/1000 LAN 2"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    localHostName = "uguisu";
  };

  services = {
    nix-daemon = {
      enable = true;
    };
  };

  system = {
    defaults = {
      dock = {
        enable-spring-load-actions-on-all-items = false;
        appswitcher-all-displays = false;
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 1.0;
        dashboard-in-overlay = false;
        expose-animation-duration = 1.0;
        expose-group-by-app = false;
        largesize = 16;
        launchanim = true;
        magnification = false;
        mineffect = "genie";
        minimize-to-application = false;
        mouse-over-hilite-stack = false;
        mru-spaces = true;
        orientation = "bottom";
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        static-only = false;
        tilesize = 48;
        wvous-bl-corner = 11;
        wvous-br-corner = 7;
        wvous-tl-corner = 10;
        wvous-tr-corner = 12;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleTemperatureUnit = "Celsius";
      };
    };
  };
}
