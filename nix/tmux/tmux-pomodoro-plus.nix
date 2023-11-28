{ tmuxPlugins, fetchFromGitHub, lib }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "pomodoro";
  version = src.rev;
  rtpFilePath = (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux";
  src = fetchFromGitHub {
    owner = "olimorris";
    repo = "tmux-pomodoro-plus";
    rev = "565d039b3b138e3add82cf67a56d01eeb975cf43";
    sha256 = "sha256-bMPdLCj5emDC1iqKU3VIZpF8tbHqALrCHUHvuf+AuHY=";
  };
  meta = {
    homepage = "https://github.com/olimorris/tmux-pomodoro-plus";
    description = "🍅 Incorporate the Pomodoro technique into your tmux workflow";
    license = lib.licenses.mit;
  };
}
