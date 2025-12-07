{pkgs, ...}: {
  services.karabiner-elements = {
    enable = true;
    # see https://github.com/nix-darwin/nix-darwin/issues/1041
    package = pkgs.karabiner-elements_14-13-0;
  };
}
