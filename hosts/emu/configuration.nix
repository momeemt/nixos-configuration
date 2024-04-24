{ config, lib, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "emu";
  networking.wireless.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  programs.zsh.enable = true;

  sops.secrets.momeemt-password.neededForUsers = true;
  sops.secrets.emu-cloudflared-cred = {};
  sops.secrets.emu-cloudflared-cred.mode = "0444"; # cloudflared reads this secret

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
    };
  };

  virtualisation.docker.enable = true;
  
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  
  system.stateVersion = "23.11";
}

