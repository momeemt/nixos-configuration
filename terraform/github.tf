provider "github" {
  token = local.github_token
}

resource "github_user_ssh_key" "emu_git" {
  title = "emu ssh key for git"
  key   = file("../assets/ssh/emu-git.pub")
}

resource "github_user_gpg_key" "momeemt_emu" {
  armored_public_key = file("../assets/gpg/emu/momeemt.asc")
}
