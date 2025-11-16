{
  config,
  pkgs,
  lib,
  nixvirtLib,
  sshKeys,
  ubuntuImage,
  name,
  uuid,
  vcpu ? 4,
  memoryGiB ? 8,
  rootDiskSizeGiB ? 30,
  bridge,
  apiAdvertiseAddress,
  ipAddress,
  gateway,
  podCIDR,
}: let
  diskPath = "/var/lib/libvirt/images/${name}.qcow2";
  seedDir = "/var/lib/libvirt/seed/${name}";
  isoPath = "${seedDir}/seed.iso";

  yaml = pkgs.formats.yaml {};

  networkConfig = yaml.generate "network-config-${name}" {
    version = 2;
    renderer = "networkd";
    ethernets.all = {
      match.name = "en*";
      dhcp4 = false;
      dhcp6 = false;
      addresses = [ipAddress];
      routes = [
        {
          to = "0.0.0.0/0";
          via = gateway;
        }
      ];
      nameservers = {
        addresses = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
  };

  userData = yaml.generate "user-data-${name}" {
    users = [
      {
        name = "ubuntu";
        ssh_authorized_keys = sshKeys;
        sudo = "ALL=(ALL) NOPASSWD:ALL";
        shell = "/bin/bash";
      }
    ];

    packages = ["qemu-guest-agent"];

    runcmd = let
      bash = cmd: ["bash" "-lc" cmd];
    in [
      (bash "mkdir -p /seed")
      (bash "mount -o ro /dev/disk/by-label/payload /seed")
      (bash "mkdir -p /etc/kubernetes/pki")
      (bash "install -m600 /seed/ca.key /etc/kubernetes/pki/ca.key")
      (bash "install -m644 /seed/ca.crt /etc/kubernetes/pki/ca.crt")
      (bash ''
        TOKEN=$(cat /seed/token) &&
        /seed/k8s-master-bootstrap.sh \
          --api-server-ip ${apiAdvertiseAddress} \
          --pod-cidr ${podCIDR} \
          --bootstrap-token "$TOKEN"
      '')
    ];
  };

  metaData = pkgs.writeText "meta-data-${name}" ''
    instance-id: ${name}
    local-hostname: ${name}
  '';

  base = nixvirtLib.domain.templates.linux {
    inherit name uuid;
    memory = {
      count = memoryGiB;
      unit = "GiB";
    };
    vcpu = {
      count = vcpu;
    };
    storage_vol = diskPath;
    bridge_name = bridge;
    virtio_drive = true;
  };

  withIso =
    base
    // {
      devices =
        (base.devices or {})
        // {
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
                source = {
                  file = isoPath;
                };
                target = {
                  dev = "sda";
                  bus = "sata";
                };
                readonly = {};
              }
              {
                type = "file";
                device = "cdrom";
                driver = {
                  name = "qemu";
                  type = "raw";
                };
                source = {
                  file = "${seedDir}/payload.iso";
                };
                target = {
                  dev = "sdb";
                  bus = "sata";
                };
                readonly = {};
              }
            ];
          interface = [
            {
              type = "bridge";
              source = {inherit bridge;};
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
  domainXml = nixvirtLib.domain.writeXML withIso;
in {
  systemd = {
    tmpfiles.rules = [
      "d ${seedDir} 0750 root root -"
    ];

    "vm-cloudinit-${name}" = {
      after = ["sops-nix.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      script = ''
        set -euo pipefail
        dir="${seedDir}"
        mkdir -p "$dir"

        install -m644 ${../assets/k8s/argocd-app-nixos-configuration.yaml} "$dir/argocd-app-nixos-configuration.yaml"
        install -m644 ${../assets/k8s/ca.crt} "$dir/ca.crt"
        install -m600 ${config.sops.secrets."k8s/ca.key".path} "$dir/ca.key"
        install -m600 ${config.sops.secrets.k8s-bootstrap-token.path} "$dir/token"

        install -m755 ${./main.sh} "$dir/k8s-master-bootstrap.sh"

        printf '%s\n' '#cloud-config' > "$dir/user-data"
        cat ${userData} >> "$dir/user-data"
        cp ${metaData} "$dir/meta-data"

        ${pkgs.cloud-utils}/bin/cloud-localds \
          --network-config ${networkConfig} \
          "${isoPath}" "$dir/user-data" "$dir/meta-data"

        ${pkgs.cdrkit}/bin/genisoimage -quiet -J -r -V payload \
          -o "${seedDir}/payload.iso" \
          "$dir/ca.crt" "$dir/ca.key" "$dir/token" \
          "$dir/k8s-master-bootstrap.sh" \
          "$dir/argocd-app-nixos-configuration.yaml"
      '';
    };

    "vm-disk-${name}" = {
      after = ["libvirtd.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      script = ''
        set -euo pipefail
        mkdir -p /var/lib/libvirt/images
        if [ ! -e "${diskPath}" ]; then
          ${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 -F qcow2 -b "${ubuntuImage}" "${diskPath}" ${toString rootDiskSizeGiB}G
          chmod 0644 "${diskPath}"
        fi
      '';
    };

    nixvirt.wants = [
      "vm-disk-${name}.service"
      "vm-cloudinit-${name}.service"
    ];

    nixvirt.after = [
      "vm-disk-${name}.service"
      "vm-cloudinit-${name}.service"
    ];
  };

  virtualisation.libvirt.connections."qemu:///system".domains = lib.mkAfter [
    {
      definition = domainXml;
      active = true;
    }
  ];
}
