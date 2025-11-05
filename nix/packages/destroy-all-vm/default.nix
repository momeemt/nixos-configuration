{pkgs, ...}:
pkgs.writeShellApplication {
  name = "destroy-all-vm";
  runtimeInputs = with pkgs; [
    libvirt
  ];
  text = builtins.readFile ../../../scripts/destroy-all-vm.sh;
}
