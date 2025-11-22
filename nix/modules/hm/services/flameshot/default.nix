{
  pkgs,
  config,
  ...
}: {
  services.flameshot = {
    enable = true;
    package = pkgs.flameshot;
    settings = {
      savePath = "${config.home.homeDirectory}/Pictures/flameshot";
      savePathFixed = true;
      filenamePattern = "%F_%H-%M-%S";
      saveAfterCopy = false;
    };
  };
}
