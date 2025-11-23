{
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings =
      {
        accept-flake-config = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        sandbox = true;
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        sandbox = true;
      };
    checkConfig = true;
    # NOTE: nh.clean.enable = true
    # gc = {
    #   automatic = true;
    # };
  };
}
