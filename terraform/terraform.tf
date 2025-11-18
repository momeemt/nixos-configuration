terraform {
  required_version = "1.13.5"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.12.0"
    }
  }

  cloud {
    organization = "momeemt"
    workspaces {
      name = "config"
    }
  }
}