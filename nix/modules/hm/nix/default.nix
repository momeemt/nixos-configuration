_: {
  nix = {
    settings = {
      accept-flake-config = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      sandbox = true;
    };
    checkConfig = true;
    # NOTE: nh.clean.enable = true
    # gc = {
    #   automatic = true;
    # };
  };
}
