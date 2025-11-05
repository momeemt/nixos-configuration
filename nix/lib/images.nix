{pkgs, ...}: {
  ubuntu-lts = pkgs.fetchurl {
    url = "https://cloud-images.ubuntu.com/noble/20251026/noble-server-cloudimg-amd64.img";
    hash = "sha256-hXQyRMyPL0c4RIDIHbtndYXSDtaTEnZn2/sRbxaC95M=";
  };
}
