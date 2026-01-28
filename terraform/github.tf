provider "github" {
  token = local.github.token
}

resource "github_user_ssh_key" "ssh_momeemt_emu_git" {
  title = "emu ssh key for git"
  key   = file("../assets/ssh/emu/momeemt/git.pub")
}

resource "github_user_ssh_key" "ssh_momeemt_uguisu_git" {
  title = "uguisu ssh key for git"
  key   = file("../assets/ssh/uguisu/momeemt/git.pub")
}

resource "github_user_ssh_key" "ssh_momeemt_kitsutsuki_git" {
  title = "kitsutsuki ssh key for git"
  key   = file("../assets/ssh/kitsutsuki/momeemt/git.pub")
}

resource "github_user_gpg_key" "gpg_momeemt_emu" {
  armored_public_key = file("../assets/gpg/emu/momeemt.asc")
}

resource "github_user_gpg_key" "gpg_momeemt_uguisu" {
  armored_public_key = file("../assets/gpg/uguisu/momeemt.asc")
}

resource "github_user_gpg_key" "gpg_momeemt_kitsutsuki" {
  armored_public_key = file("../assets/gpg/kitsutsuki/momeemt.asc")
}

data "github_repository" "config" {
  full_name = "momeemt/config"
}

resource "github_actions_secret" "sops_age_key" {
  repository      = data.github_repository.config.name
  secret_name     = "SOPS_AGE_KEY"
  plaintext_value = local.secrets.ci.sops_age_key
}

resource "github_branch_protection" "config_develop" {
  repository_id = data.github_repository.config.node_id
  pattern       = "develop"

  required_pull_request_reviews {
    required_approving_review_count = 0
  }

  allows_force_pushes = false
  allows_deletions    = false
}

resource "github_branch_protection" "config_main" {
  repository_id = data.github_repository.config.node_id
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 0
  }

  required_status_checks {
    strict = true
    contexts = [
      "flake-check",
      "nix-build (ciConfigurations.emu.config.system.build.toplevel, ubuntu-24.04)",
      "nix-build (ciConfigurations.shime.config.system.build.toplevel, ubuntu-24.04)",
      "nix-build (darwinConfigurations.uguisu.system, macos-15)",
      "nix-build (homeConfigurations.example.activationPackage, ubuntu-24.04)",
      "container-build",
    ]
  }

  allows_force_pushes = false
  allows_deletions    = false
}
