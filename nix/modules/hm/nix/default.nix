{pkgs, ...}: {
  nix = {
    package = pkgs.nix;
    settings = {
      accept-flake-config = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      sandbox = true;
    };
    checkConfig = true;
    channels = {
      nixpkgs = pkgs.path;
    };
    gc = {
      automatic = true;
    };
  };
}
