{
  pkgs,
  lib,
  config,
  siteLib,
  inputs,
  ...
}: let
  cfg = config.k8sVMs;
  nixvirtLib = inputs.NixVirt.lib;
in {
  options.k8sVMs.enable = lib.mkEnableOption "k8s VMs (master and workers)";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (siteLib.mkK8sMaster {
      inherit pkgs lib config nixvirtLib;
      name = "kube-master";
      uuid = "c0ffee00-0001-0000-0000-000000000001";
      vcpu = 4;
      memoryGiB = 8;
      rootDiskSizeGiB = 30;
      bridge = "br0";
      ubuntuImage = siteLib.images.ubuntu-lts;
      ipAddress = "${siteLib.ip.kube-master}/23";
      podCIDR = "10.244.0.0/16";
      sshKeys = siteLib.publicKeys;
      apiAdvertiseAddress = siteLib.ip.kube-master;
      gateway = siteLib.ip.defaultGateway;
    })
    (siteLib.mkK8sWorker {
      inherit pkgs lib config nixvirtLib;
      name = "kube-worker-emu-1";
      uuid = "c0ffee00-0001-0000-0000-000000000002";
      vcpu = 4;
      memoryGiB = 8;
      rootDiskSizeGiB = 30;
      bridge = "br0";
      ipAddress = "${siteLib.ip.kube-worker-emu-1}/23";
      ubuntuImage = siteLib.images.ubuntu-lts;
      sshKeys = siteLib.publicKeys;
      apiAdvertiseAddress = siteLib.ip.kube-master;
      gateway = siteLib.ip.defaultGateway;
      caHash = siteLib.k8sCaCertHash;
    })
    (siteLib.mkK8sWorker {
      inherit pkgs lib config nixvirtLib;
      name = "kube-worker-emu-2";
      uuid = "c0ffee00-0001-0000-0000-000000000003";
      vcpu = 4;
      memoryGiB = 8;
      rootDiskSizeGiB = 30;
      bridge = "br0";
      ipAddress = "${siteLib.ip.kube-worker-emu-2}/23";
      ubuntuImage = siteLib.images.ubuntu-lts;
      sshKeys = siteLib.publicKeys;
      apiAdvertiseAddress = siteLib.ip.kube-master;
      gateway = siteLib.ip.defaultGateway;
      caHash = siteLib.k8sCaCertHash;
    })
  ]);
}
