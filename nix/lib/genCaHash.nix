{
  pkgs,
  caCertPath,
}: let
  caHashFile =
    pkgs.runCommand "k8s-ca-hash" {
      buildInputs = with pkgs; [openssl coreutils];
    } ''
      set -euo pipefail
      openssl x509 -pubkey -noout -in ${caCertPath} \
        | openssl pkey -pubin -outform der \
        | sha256sum \
        | cut -d' ' -f1 > "$out"
    '';
in
  builtins.replaceStrings ["\n"] [""] (builtins.readFile caHashFile)
