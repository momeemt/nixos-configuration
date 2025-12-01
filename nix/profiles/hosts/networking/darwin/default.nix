let
  networkingLib = import ../lib.nix {};
in {
  networking = {
    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
      allowSigned = true;
      allowSignedApp = true;
      blockAllIncoming = false;
    };
    dns = networkingLib.nameservers;
    knownNetworkServices = [
      "USB 10/100/1000 LAN"
      "USB 10/100/1000 LAN 2"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
  };
}
