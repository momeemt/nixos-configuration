{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  ubuntuCloudImg = pkgs.fetchurl {
    url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img";
    hash = "sha256-KSQNidvU5ObZS+KzUxrVJFsCJ/FtVtG7esVnT0/NTKo=";
  };

  userData = pkgs.writeText "user-data" (
    "#cloud-config\n"
    + lib.generators.toYAML {} {
      users = [
        {
          name = "ubuntu";
          ssh_authorized_keys = (import ../../system/ssh.nix).public_keys;
          sudo = "ALL=(ALL) NOPASSWD:ALL";
          shell = "/bin/bash";
        }
      ];

      packages = ["qemu-guest-agent"];

      network = {
        version = 2;
        renderer = "networkd";
        ethernets.all = {
          match.name = "en*";
          dhcp4 = true;
          dhcp6 = true;
        };
      };

      runcmd = [
        "systemctl enable --now qemu-guest-agent.service"
        "systemctl enable --now serial-getty@ttyS0.service"
      ];
    }
  );

  metaData = pkgs.writeText "meta-data" ''
    instance-id: kube-master
    local-hostname: kube-master
  '';

  cloudInitIso =
    pkgs.runCommand "cloudinit-kube-master.iso" {
      buildInputs = with pkgs; [cloud-utils];
    } ''
      cloud-localds $out ${userData} ${metaData}
    '';

  diskMaster = "/var/lib/libvirt/images/kube-master.qcow2";
  nixvirt = inputs.NixVirt.lib;
  base = nixvirt.domain.templates.linux {
    name = "kube-master";
    uuid = "c0ffee00-0000-0000-0000-000000000001";
    memory = {
      count = 8;
      unit = "GiB";
    };
    storage_vol = diskMaster;
    bridge_name = "br0";
    virtio_drive = true;
  };
  withFix =
    base
    // {
      devices = {
        disk =
          (base.devices.disk or [])
          ++ [
            {
              type = "file";
              device = "cdrom";
              driver = {
                name = "qemu";
                type = "raw";
              };
              source = {file = "${cloudInitIso}";};
              target = {
                dev = "sda";
                bus = "sata";
              };
              readonly = {};
            }
          ];
        interface = [
          {
            type = "bridge";
            source = {
              bridge = "br0";
            };
            model = {
              type = "virtio";
            };
          }
        ];
        serial = [
          {
            type = "pty";
            target = {
              port = 0;
            };
          }
        ];
        console = [
          {
            type = "pty";
            target = {
              type = "serial";
              port = 0;
            };
          }
        ];
        channel = [
          {
            type = "unix";
            target = {
              type = "virtio";
              name = "org.qemu.guest_agent.0";
            };
          }
        ];
      };
    };
  domainMasterXml = nixvirt.domain.writeXML withFix;
in {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "emu";
    useNetworkd = true;

    interfaces.enp3s0.useDHCP = false;
    bridges.br0.interfaces = ["enp3s0"];

    interfaces.br0.ipv4.addresses = [
      {
        address = "192.168.32.145";
        prefixLength = 23;
      }
    ];

    defaultGateway = {
      address = "192.168.32.1";
      interface = "br0";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [3389];
      allowedUDPPorts = [3389];
    };

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "quartus-prime-lite-unwrapped"
      "quartus-prime-lite"
      "copilot.vim"
      "google-chrome"
      "spotify"
      "discord"
      "todoist-electron"
      "vscode"
      "vscode-extension-ms-vscode-remote-remote-containers"
      "vscode-extension-ms-vscode-remote-remote-ssh"
      "vscode-extension-ms-vscode-remote-remote-ssh-edit"
    ];

  programs.zsh.enable = true;

  sops.secrets.momeemt-password.neededForUsers = true;

  sops.secrets.emu-cloudflared-cred = {};
  sops.secrets.emu-cloudflared-cred.mode = "0444"; # cloudflared reads this secret

  sops.secrets.emu-desktop-cloudflared-cred = {};
  sops.secrets.emu-desktop-cloudflared-cred.mode = "0444";

  users.users.momeemt = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.momeemt-password.path;
    openssh.authorizedKeys.keys = (import ../../system/ssh.nix).public_keys;
  };

  sops.defaultSopsFile = ../../secrets/secrets.yml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
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
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs; [
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

  services.udev.packages = [pkgs.usb-blaster-udev-rules];

  virtualisation.docker.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  systemd.services."vm-disk-kube-master" = {
    description = "Create qcow2 disk for kube-master if missing";
    after = ["libvirtd.service"];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      set -euo pipefail
      mkdir -p /var/lib/libvirt/images
      if [ ! -e "${diskMaster}" ]; then
        ${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 -F qcow2 -b "${ubuntuCloudImg}" "${diskMaster}" 30G
        chmod 0644 "${diskMaster}"
      fi
    '';
    wantedBy = ["multi-user.target"];
  };

  virtualisation.libvirt = {
    enable = true;
    verbose = true;
    connections."qemu:///system" = {
      pools = null;
      domains = [
        {
          definition = domainMasterXml;
          active = true;
        }
      ];
    };
  };

  programs.virt-manager.enable = true;

  system.stateVersion = "23.11";
}
