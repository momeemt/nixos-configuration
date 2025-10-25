{
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
  bridge ? "br0",
  apiAdvertiseAddress,
  podCIDR,
}: let
  diskPath = "/var/lib/libvirt/images/${name}.qcow2";
  userData = pkgs.writeText "user-data-${name}" (
    "#cloud-config\n"
    + lib.generators.toYAML {} {
      users = [
        {
          name = "ubuntu";
          ssh_authorized_keys = sshKeys;
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

      write_files = [
        {
          path = "/usr/local/sbin/k8s-master-bootstrap.sh";
          permissions = "0755";
          content = builtins.readFile ./k8s-master-bootstrap.sh;
        }
      ];

      runcmd = [
        "/usr/local/sbin/k8s-master-bootstrap.sh --api-server-ip ${apiAdvertiseAddress} --pod-cidr ${podCIDR}"
      ];
    }
  );

  metaData = pkgs.writeText "meta-data-${name}" ''
    instance-id: ${name}
    local-hostname: ${name}
  '';

  cloudInitIso =
    pkgs.runCommand "cloudinit-${name}.iso" {
      buildInputs = [pkgs.cloud-utils];
    } ''
      cloud-localds $out ${userData} ${metaData}
    '';

  base = nixvirtLib.domain.templates.linux {
    inherit name uuid;
    memory = {
      count = memoryGiB;
      unit = "GiB";
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
                  file = "${cloudInitIso}";
                };
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
  domainXml = nixvirtLib.domain.writeXML withIso;
in {
  systemd.services."vm-disk-${name}" = {
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

  systemd.services.nixvirt.wants = ["vm-disk-${name}.service"];
  systemd.services.nixvirt.after = ["vm-disk-${name}.service"];
  virtualisation.libvirt.connections."qemu:///system".domains = lib.mkAfter [
    {
      definition = domainXml;
      active = true;
    }
  ];
}
