{pkgs, ...}:
with pkgs.terraform-providers; [
  pkgs.terraform
  pkgs.driftctl
  hashicorp_random
  cloudflare_cloudflare
  carlpett_sops
  integrations_github
]
