provider "sops" {}

data "sops_file" "secrets" {
  source_file = "../secrets/secrets.enc.yml"
}

locals {
  cloudflare_api_token = data.sops_file.secrets.data["cloudflare_api_token"]
  cloudflare_zone_id   = data.sops_file.secrets.data["cloudflare_zone_id"]
}
