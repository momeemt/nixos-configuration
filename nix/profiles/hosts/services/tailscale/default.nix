{
  networking.firewall.trustedInterfaces = ["tailscale0"];
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [
      "--netfilter-mode=nodivert"
    ];
  };
}
