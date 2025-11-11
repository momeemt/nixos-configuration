_: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    formatter = pkgs.alejandra;

    devShells.default = pkgs.mkShell {
      inputsFrom = [
        config.treefmt.build.devShell
        config.pre-commit.devShell
      ];
      buildInputs = with pkgs; [
        sops
        # Development utilities
        fd
        ripgrep
        fzf
        jq
        yq
        # Nix tools
        nix-tree
        nix-output-monitor
        nixpkgs-fmt
        statix
        deadnix
        # Git tools
        git-crypt
        gitAndTools.gh
      ];
      shellHook = ''
        echo "🎉 NixOS Configuration Development Shell"
        echo ""
        echo "Quick commands:"
        echo "  devtools          - All-in-one development toolkit"
        echo "  devtools check    - Run all checks (fmt + lint + build)"
        echo "  devtools switch   - Quick configuration switch"
        echo "  devtools help     - Show all available commands"
        echo ""
        echo "Traditional commands:"
        echo "  make apply        - Apply configuration to current host"
        echo "  treefmt           - Format all files"
        echo "  nix flake check   - Run flake checks"
        echo ""
      '';
    };

    packages = {
      encrypt-secrets = pkgs.callPackage ../packages/encrypt-secrets {};
      updatekeys-secrets = pkgs.callPackage ../packages/updatekeys-secrets {};
      destroy-all-vm = pkgs.callPackage ../packages/destroy-all-vm {};
      switch-config-branch = pkgs.callPackage ../packages/switch-config-branch {};
      nix-update = pkgs.callPackage ../packages/nix-update {};
      nix-clean = pkgs.callPackage ../packages/nix-clean {};
      quick-switch = pkgs.callPackage ../packages/quick-switch {};
      devtools = pkgs.callPackage ../packages/devtools {};
      setup-dev = pkgs.callPackage ../packages/setup-dev {};
      treefmt = config.treefmt.build.wrapper;
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

    pre-commit = {
      check.enable = true;
      settings = {
        hooks = {
          treefmt.enable = true;
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    };
  };
}
