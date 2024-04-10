{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "emu"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  users.users.momeemt = {
    isNormalUser = true; 
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      neofetch
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    gh
    zsh
  ];

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

