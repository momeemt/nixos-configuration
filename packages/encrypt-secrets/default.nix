{pkgs, ...}:
pkgs.writeShellApplication {
  name = "encrypt-secrets";
  runtimeInputs = with pkgs; [
    sops
    findutils
    coreutils
  ];
  text = builtins.readFile ../../scripts/encrypt-secrets.sh;
}
