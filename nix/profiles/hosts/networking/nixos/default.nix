let
  networkingLib = import ../lib.nix {};
in {
  networking = {
    inherit (networkingLib) nameservers;
    firewall = {
      enable = true;
      allowedTCPPorts = [3389];
      allowedUDPPorts = [3389];
    };
  };
}
