{ config, lib, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "emu"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  programs.zsh.enable = true;

  users.users.momeemt = {
    isNormalUser = true; 
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  services.openssh.enable = true;
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1" "8.8.8.8" "8.8.4.4" ];
    dnsovertls = "true";
  };
  
  system.stateVersion = "23.11";
}

