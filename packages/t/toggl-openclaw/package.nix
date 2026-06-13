{pkgs, ...}:
pkgs.writeShellApplication {
  name = "toggl-openclaw";
  runtimeInputs = with pkgs; [
    coreutils
    curl
    jq
  ];
  text = builtins.readFile ./main.sh;
}
