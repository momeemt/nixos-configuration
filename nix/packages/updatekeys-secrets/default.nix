{pkgs, ...}:
pkgs.writeShellApplication {
  name = "updatekeys-secrets";
  runtimeInputs = with pkgs; [
    sops
    findutils
    coreutils
  ];
  text = builtins.readFile ../../../scripts/updatekeys-secrets.sh;
}
