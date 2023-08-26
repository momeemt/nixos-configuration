{ pkgs, ... }:
{
  services = {
    nix-daemon = {
      enable = true;
    };

    yabai = {
      enable = true;
    };
  };
}
