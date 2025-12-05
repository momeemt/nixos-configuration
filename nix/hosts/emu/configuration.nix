{
  config,
  pkgs,
  siteLib,
  ...
}: {
  imports = [
    ../../profiles/sops
    ../../profiles/comin
    ../../profiles/hosts/services/displayManager
    ../../profiles/hosts/services/openssh
    ../../profiles/hosts/services/resolved
    ../../profiles/hosts/services/xrdp
    ../../profiles/hosts/services/xserver
    ../../profiles/hosts
    ./k8s
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "emu";
    useNetworkd = true;

    interfaces = {
      enp3s0.useDHCP = false;

      br0.ipv4.addresses = [
        {
          address = siteLib.ip.emu;
          prefixLength = 23;
        }
      ];
    };

    bridges.br0.interfaces = ["enp3s0"];

    defaultGateway = {
      address = siteLib.ip.defaultGateway;
      interface = "br0";
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  users.users.momeemt = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.momeemt-password.path;
    openssh.authorizedKeys.keys = siteLib.publicKeys;
  };

  services = {
    cloudflared = {
      enable = true;
      tunnels = {
        "053a4ebe-82c3-485a-bc8b-f0768cbe1d11" = {
          credentialsFile = "${config.sops.secrets."cloudflared/emu.json".path}";
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
          credentialsFile = "${config.sops.secrets."cloudflared/emu-desktop.json".path}";
          ingress = {
            "emu-desktop.momee.mt" = {
              service = "rdp://localhost:3389";
            };
          };
          default = "http_status:404";
        };
      };
    };

    udev.packages = [pkgs.usb-blaster-udev-rules];
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

  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
      };
    };

    libvirt = {
      enable = true;
      verbose = true;
      connections."qemu:///system".pools = null;
    };
  };
}
