{ tmuxPlugins, fetchFromGitHub }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "sensible";
  version = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
  rtpFilePath = (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux";
  src = fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-sensible";
    rev = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
    sha256 = "sha256-sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
  };
}
