{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    package = pkgs.zoxide;
  };
}
