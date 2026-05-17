{inputs, ...}: {
  perSystem = {
    pkgs,
    pkgs-25_05,
    config,
    system,
    ...
  }: let
    inputsFrom = with config; [
      treefmt.build.devShell
      just-flake.outputs.devShell
      pre-commit.devShell
    ];
  in {
    devShells = {
      default = pkgs.mkShell {
        inherit inputsFrom;
        buildInputs = with pkgs; [
          # config.files.writer.drv
          sops
          inputs.nur-packages.legacyPackages.${system}.aicommit
          encrypt-secrets
          updatekeys-secrets
          destroy-all-vm
          switch-config-branch
        ];
      };
      growth = import ../../assets/growth/devShell.nix {
        pkgs = pkgs-25_05;
        inherit inputsFrom;
      };
      obsidian = pkgs.mkShell {
        inherit inputsFrom;
        buildInputs = with pkgs; [
          git
          nodejs_22
          rsync
        ];
      };
      terraform = import ../../terraform/devShell.nix {inherit pkgs inputsFrom;};
      k8s = import ../../k8s/devShell.nix {inherit pkgs inputsFrom;};
    };
  };
}
