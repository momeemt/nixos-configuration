{
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = [
      "1.1.1.1"
      "8.8.8.8"
      "8.8.4.4"
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ];
    dnsovertls = "true";
  };
}
