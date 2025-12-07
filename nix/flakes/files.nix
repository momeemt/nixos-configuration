_: {
  perSystem = {pkgs, ...}: {
    files.files = [
      {
        path_ = "LICENSE";
        drv = let
          year = "2025";
        in
          pkgs.runCommand "LICENSE" {} ''
            set -eu
              license=$(${pkgs.license-go}/bin/license apache-2.0)
              year="${year}"
              license="''${license//\[yyyy\]/$year}"
              license="''${license//\[name of copyright owner\]/Mutsuha Asada}"
              echo "$license" > "$out"
          '';
      }
    ];
  };
}
