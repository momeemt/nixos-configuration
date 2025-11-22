provider "github" {
  token = local.github_token
}

resource "github_user_ssh_key" "emu_git" {
  title = "emu ssh key for git"
  key   = file("../assets/ssh/emu-git.pub")
}
