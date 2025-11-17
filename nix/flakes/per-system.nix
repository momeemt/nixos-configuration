{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    formatter = pkgs.alejandra;

    devShells.default = pkgs.mkShell {
      inputsFrom = [
        config.treefmt.build.devShell
        config.just-flake.outputs.devShell
      ];
      buildInputs = with pkgs; [
        sops
        terraform
        nodejs_24
      ];
    };

    packages = {
      encrypt-secrets = pkgs.callPackage ../packages/encrypt-secrets {};
      updatekeys-secrets = pkgs.callPackage ../packages/updatekeys-secrets {};
      destroy-all-vm = pkgs.callPackage ../packages/destroy-all-vm {};
      switch-config-branch = pkgs.callPackage ../packages/switch-config-branch {};
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
