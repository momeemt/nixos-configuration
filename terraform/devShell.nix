{
  pkgs,
  inputsFrom,
}: let
  terraform-providers = with pkgs.terraform-providers; [
    hashicorp_random
    cloudflare_cloudflare
    carlpett_sops
    integrations_github
  ];
in
  pkgs.mkShell {
    inherit inputsFrom;
    buildInputs = with pkgs;
      [
        terraform
        driftctl
      ]
      ++ terraform-providers;
  }
