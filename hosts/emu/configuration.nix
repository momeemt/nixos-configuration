{ config, lib, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "emu";
  networking.networkmanager.enable = false;
  networking.wireless.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3389 ];
    allowedUDPPorts = [ 3389 ];
  };
  
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "quartus-prime-lite-unwrapped"
    ];

  programs.zsh.enable = true;

  sops.secrets.momeemt-password.neededForUsers = true;

  sops.secrets.emu-cloudflared-cred = {};
  sops.secrets.emu-cloudflared-cred.mode = "0444"; # cloudflared reads this secret

  sops.secrets.emu-desktop-cloudflared-cred = {};
  sops.secrets.emu-desktop-cloudflared-cred.mode = "0444";

  users.users.momeemt = {
    isNormalUser = true; 
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.momeemt-password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMRWePf8csR+2HrGf1ZDKnsf0JZek59a5v4oinU9tTFG momeemt@uguisu"
    ];
  };

  sops.defaultSopsFile = ../../secrets/secrets.yml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1" "8.8.8.8" "8.8.4.4" ];
    dnsovertls = "true";
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "053a4ebe-82c3-485a-bc8b-f0768cbe1d11" = {
        credentialsFile = "${config.sops.secrets.emu-cloudflared-cred.path}";
        ingress = {
          "emu.momee.mt" = {
            service = "ssh://localhost:22";
          };
          "s3.momee.mt" = {
            service = "http://localhost:9000";
          };
        };
        default = "http_status:404";
      };
      "b2b83e61-577c-45e7-b1c0-0961503e8d8d" = {
        credentialsFile = "${config.sops.secrets.emu-desktop-cloudflared-cred.path}";
        ingress = {
          "emu-desktop.momee.mt" = {
            service = "rdp://localhost:3389";
          };
        };
        default = "http_status:404";
      };
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/100390
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';

  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.gnome3.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gnome-terminal
    gedit
    epiphany
    geary
    evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  services.udev.packages = [ pkgs.usb-blaster-udev-rules ];

  virtualisation.docker.enable = true;
  
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  
  system.stateVersion = "23.11";
}

