{pkgs, ...}: {
  services.aerospace = {
    enable = true;
    package = pkgs.aerospace;
    # launchd.enable = true;
    settings = {
      gaps = {
        outer = {
          left = 8;
          bottom = 8;
          top = 8;
          right = 8;
        };
      };
      mode.main.binding = {
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
      };
    };
  };
}
