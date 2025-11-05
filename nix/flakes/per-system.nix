{...}: {
  perSystem = {
    pkgs,
    config,
    lib,
    ...
  }: {
    formatter = pkgs.alejandra;

    devShells.default = pkgs.mkShell {
      inputsFrom = [
        config.treefmt.build.devShell
      ];
      buildInputs = with pkgs; [
        sops
      ];
    };

    packages = {
      encrypt-secrets = pkgs.callPackage ../../packages/encrypt-secrets.nix {};
      updatekeys-secrets = pkgs.callPackage ../../packages/updatekeys-secrets.nix {};
      destroy-all-vm = pkgs.callPackage ../../packages/destroy-all-vm.nix {};
      switch-config-branch = pkgs.callPackage ../../packages/switch-config-branch.nix {};
    };

    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        actionlint.enable = true;
        alejandra.enable = true;
        deadnix.enable = true;
        mdformat.enable = true;
        shellcheck.enable = true;
        shfmt = {
          enable = true;
          includes = [
            "*.sh"
            "*.bash"
            "*.envrc"
            "*.envrc.*"
            "*.zsh"
            "**/zshrc"
            "**/zprofile"
          ];
        };
        statix.enable = true;
        stylua.enable = true;
        yamlfmt.enable = true;
      };
      settings.global.excludes = [
        "LICENSE-*"
        "secrets/secrets.yml"
        ".github/CODEOWNERS"
        ".gitattributes"
        "modules/tmux/tmux.conf"
        "*.vim"
        "Makefile"
      ];
    };
  };
}
