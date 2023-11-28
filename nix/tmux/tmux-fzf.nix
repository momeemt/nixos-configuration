{ tmuxPlugins, fetchFromGitHub, bash, gnused, fzf, pstree, lib }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "fzf";
  version = src.rev;
  rtpFilePath = "main.tmux";
  src = fetchFromGitHub {
    owner = "sainnhe";
    repo = "tmux-fzf";
    rev = "d62b6865c0e7c956ad1f0396823a6f34cf7452a7";
    sha256 = "sha256-hVkSQYvBXrkXbKc98V9hwwvFp6z7/mX1K4N3N9j4NN4=";
  };
  nativeBuildInputs = [ bash gnused fzf pstree ];
  # postInstall = ''
  #   sed -i -e 's|python3 |${python311Env}/bin/python3 |g' $target/tmux_window_name.tmux
  #   sed -i -e 's|'ps'|'${ps}/bin/ps'|g' $target/scripts/rename_session_windows.py
  #   sed -i -e 's|#!/usr/bin/env python3|#!${python311Env}/bin/python3|g' $target/scripts/rename_session_windows.py
  # '';
  meta = {
    homepage = "https://github.com/sainnhe/tmux-fzf";
    description = "Use fzf to manage your tmux work environment!";
    license = lib.licenses.mit;
  };
}
