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

resource "github_actions_secret" "sops_age_key" {
  repository      = "config"
  secret_name     = "SOPS_AGE_KEY"
  plaintext_value = local.secrets.ci.sops_age_key
}

resource "github_actions_secret" "cloudflare_account_id" {
  repository      = "monorepo"
  secret_name     = "CLOUDFLARE_ACCOUNT_ID"
  plaintext_value = local.cloudflare.account_id
}

resource "github_actions_secret" "cloudflare_api_token" {
  repository      = "monorepo"
  secret_name     = "CLOUDFLARE_API_TOKEN"
  plaintext_value = local.cloudflare.api_token
}
