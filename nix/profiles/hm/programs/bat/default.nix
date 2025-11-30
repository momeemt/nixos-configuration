{pkgs, ...}: {
  programs.bat = {
    enable = true;
    package = pkgs.bat;
    extraPackages = [pkgs.bat-extras.core];
    config = {
      theme = "TwoDark";
    };
  };
}
