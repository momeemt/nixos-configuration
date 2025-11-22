{pkgs, ...}: {
  programs.man = {
    enable = true;
    package = pkgs.man;
    generateCaches = true;
  };
}
