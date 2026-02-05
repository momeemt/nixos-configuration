terraform {
  required_version = "1.14.3"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.16.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.11.0"
    }
  }

  cloud {
    organization = "momeemt"
    workspaces {
      name = "config"
    }
  }
}

