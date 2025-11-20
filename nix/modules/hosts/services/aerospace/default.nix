{pkgs, ...}: {
  imports = [
    ./main.nix
    ./service.nix
  ];

  services.aerospace = {
    enable = true;
    package = pkgs.aerospace;
    settings = {
      gaps = {
        outer = {
          left = 8;
          bottom = 8;
          top = 8;
          right = 8;
        };
      };
    };
  };
}
