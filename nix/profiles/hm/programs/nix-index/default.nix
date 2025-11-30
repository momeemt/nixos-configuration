{pkgs, ...}: {
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    package = pkgs.nix-index;
  };
}
