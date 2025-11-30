{inputs, ...}: {
  perSystem = {
    pkgs,
    pkgs-master,
    config,
    system,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = with config; [
        treefmt.build.devShell
        just-flake.outputs.devShell
        pre-commit.devShell
      ];

      buildInputs = with pkgs;
        [
          sops
          nodejs_24
          kubectl
          kubernetes-helm
          inputs.nur-packages.legacyPackages.${system}.aicommit
          encrypt-secrets
          updatekeys-secrets
          destroy-all-vm
          switch-config-branch
        ]
        ++ (import ../../terraform/terraform.nix {pkgs = pkgs-master;});
    };
  };
}
