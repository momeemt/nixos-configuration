{ tmuxPlugins, fetchFromGitHub, lib }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "battery";
  version = src.rev;
  rtpFilePath = (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux";
  src = fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-battery";
    rev = "5c52d4f7f80384de0781c2277a8989ba98fae507";
    sha256 = "sha256-+ZFbNY17LnuD4k8YfM8KuIsy2zq78YburDQKKHnzeVw=";
  };
  meta = {
    homepage = "https://github.com/tmux-plugins/tmux-battery";
    description = "Plug and play battery percentage and icon indicator for Tmux.";
    license = lib.licenses.mit;
  };
}
