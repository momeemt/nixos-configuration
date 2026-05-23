_: {
  perSystem = {pkgs, ...}: {
    packages = {
      attic-pack = import ../../packages/attic-pack/package.nix {
        inherit pkgs;
      };
      obsidian = import ../../packages/obsidian/package.nix {
        inherit pkgs;
      };
      slides = import ../../packages/slides/package.nix {
        inherit pkgs;
      };
    };
  };
}
