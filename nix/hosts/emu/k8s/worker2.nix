{
  pkgs,
  lib,
  config,
  siteLib,
  inputs,
  ...
}: let
  nixvirtLib = inputs.NixVirt.lib;
in
  siteLib.mkK8sWorker {
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
    caHash = siteLib.genCaHash ../../../../assets/k8s/ca.crt;
  }
