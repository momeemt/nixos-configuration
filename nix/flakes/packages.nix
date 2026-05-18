_: {
  perSystem = {pkgs, ...}: {
    packages = {
      obsidian = import ../../packages/obsidian/package.nix {
        inherit pkgs;
      };
      slides = import ../../packages/slides/package.nix {
        inherit pkgs;
      };
    };
  };
}
