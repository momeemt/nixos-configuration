terraform {
  required_version = "1.14.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.12.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.8.3"
    }
  }

  cloud {
    organization = "momeemt"
    workspaces {
      name = "config"
    }
  }
}

