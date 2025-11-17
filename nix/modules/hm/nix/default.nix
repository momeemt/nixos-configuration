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
    gc = {
      automatic = true;
    };
  };
}
