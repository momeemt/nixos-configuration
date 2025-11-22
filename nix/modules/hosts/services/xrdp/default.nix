{pkgs, ...}: {
  services.xrdp = {
    enable = true;
    package = pkgs.xrdp;
    port = 3389;
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };
}
