{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    system,
    ...
  }: {
    _module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = import ../overlays;
      };
      pkgs-master = import inputs.nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    };

    formatter = pkgs.alejandra;

    packages = {
      treefmt = config.treefmt.build.wrapper;
    };

    checks = {
      formatting = config.treefmt.build.check config.treefmt.projectRoot;
    };

    just-flake.features = {
      treefmt.enable = true;
    };

    pre-commit = {
      check.enable = true;
      settings = {
        hooks = {
          treefmt.enable = true;
        };
      };
    };

    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        actionlint.enable = true;
        alejandra.enable = true;
        deadnix.enable = true;
        mdformat.enable = true;
        ruff-check.enable = true;
        ruff-format.enable = true;
        shellcheck.enable = true;
        shfmt = {
          enable = true;
          includes = [
            "*.sh"
            "*.bash"
          ];
        };
        statix.enable = true;
        stylua.enable = true;
        terraform.enable = true;
        yamlfmt.enable = true;
      };
      settings.global.excludes = [
        "LICENSE-*"
        "secrets/*"
        ".github/CODEOWNERS"
        ".gitattributes"
        "modules/tmux/tmux.conf"
        "*.vim"
        "Makefile"
      ];
    };
  };
}
