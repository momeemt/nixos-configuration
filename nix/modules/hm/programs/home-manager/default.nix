{config, ...}: {
  programs.home-manager = {
    enable = true;
    path = "${config.xdg.configHome}/nixpkgs/home-manager";
  };
}
