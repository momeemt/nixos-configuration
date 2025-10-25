{pkgs, ...}: {
  ubuntu-lts = pkgs.fetchurl {
    url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img";
    hash = "sha256-KSQNidvU5ObZS+KzUxrVJFsCJ/FtVtG7esVnT0/NTKo=";
  };
}
