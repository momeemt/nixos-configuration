_: {
  perSystem = {pkgs, ...}: {
    packages = {
      attic-pack = import ../../packages/a/attic-pack/package.nix {
        inherit pkgs;
      };
      obsidian = import ../../packages/o/obsidian/package.nix {
        inherit pkgs;
      };
      slides = import ../../packages/s/slides/package.nix {
        inherit pkgs;
      };
    };
  };
}
