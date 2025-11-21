{pkgs, ...}: {
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    package = pkgs.eza;
    colors = "auto";
    git = true;
    icons = "auto";

    extraOptions = [
      "--group-directories-first"
      "--long"
      "--all"
    ];
  };
}
