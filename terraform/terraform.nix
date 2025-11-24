{pkgs, ...}:
with pkgs.terraform-providers; [
  pkgs.terraform
  pkgs.driftctl
  cloudflare_cloudflare
  carlpett_sops
  integrations_github
]
