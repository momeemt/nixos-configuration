{
  pkgs,
  lib,
  config,
  siteLib,
  inputs,
  ...
}: let
  cfg = config.k8sWorkers;
  nixvirtLib = inputs.NixVirt.lib;
in {
  options.k8sWorkers.enable = lib.mkEnableOption "k8s worker VMs";

  config = lib.mkIf cfg.enable (
    siteLib.mkK8sWorker {
      inherit pkgs lib config nixvirtLib;
      name = "kube-worker-shime-1";
      uuid = "c0ffee00-0002-0000-0000-000000000001";
      vcpu = 4;
      memoryGiB = 8;
      rootDiskSizeGiB = 30;
      bridge = "br0";
      ipAddress = "${siteLib.ip.kube-worker-shime-1}/23";
      ubuntuImage = siteLib.images.ubuntu-lts;
      sshKeys = siteLib.publicKeys;
      apiAdvertiseAddress = siteLib.ip.kube-master;
      gateway = siteLib.ip.defaultGateway;
      caHash = siteLib.k8sCaCertHash;
    }
  );
}
