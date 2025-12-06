{pkgs, ...}: {
  services.karabiner-elements = {
    enable = true;
    package = pkgs.karabiner-elements;
  };
}
