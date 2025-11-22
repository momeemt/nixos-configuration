{pkgs, ...}:
with pkgs.terraform-providers; [
  pkgs.terraform
  cloudflare_cloudflare
  carlpett_sops
  integrations_github
]
