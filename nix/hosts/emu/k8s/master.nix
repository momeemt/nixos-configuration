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
  siteLib.mkK8sMaster {
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
  }
