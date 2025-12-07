{inputs, ...}: {
  perSystem = {
    pkgs,
    pkgs-master,
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
      terraform = import ../../terraform/devShell.nix {
        pkgs = pkgs-master;
        inherit inputsFrom;
      };
      k8s = import ../../k8s/devShell.nix {inherit pkgs inputsFrom;};
    };
  };
}
