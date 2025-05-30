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

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = ["momeemt"];
    };
  };

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
