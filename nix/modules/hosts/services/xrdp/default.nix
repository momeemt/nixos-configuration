{pkgs, ...}: {
  services.xrdp = {
    enable = true;
    package = pkgs.xrdp;
    port = 3389;
    defaultWindowManager = "${pkgs.sway}/bin/sway";
    openFirewall = true;
  };
}
