{
  pkgs,
  lib,
  ...
}: {
  home.activation.installHomebrewAndBundle = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export BREWFILE="${./Brewfile}"
    export PATH="${pkgs.curl}/bin:${pkgs.bash}/bin:$PATH"
    ${pkgs.bash}/bin/bash ${./install-homebrew.sh}
  '';
}
