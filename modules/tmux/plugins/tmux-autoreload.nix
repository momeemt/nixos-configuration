{ tmuxPlugins, fetchFromGitHub, entr, ps, lib }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tmux-autoreload";
  version = "e98aa3b74cfd5f2df2be2b5d4aa4ddcc843b2eba";
  rtpFilePath = pluginName + ".tmux";
  src = fetchFromGitHub {
    owner = "b0o";
    repo = "tmux-autoreload";
    rev = "e98aa3b74cfd5f2df2be2b5d4aa4ddcc843b2eba";
    sha256 = "sha256-9Rk+VJuDqgsjc+gwlhvX6uxUqpxVD1XJdQcsc5s4pU4=";
  };
  nativeBuildInputs = [ entr ];
  postInstall = ''
    sed -i -e 's|entr |${entr}/bin/entr |g' $target/tmux-autoreload.tmux
    sed -i -e 's|ps |${ps}/bin/ps |g' $target/tmux-autoreload.tmux
  '';
  meta = {
    homepage = "https://github.com/b0o/tmux-autoreload";
    description = "🧐 Automatically reload your tmux config file on change";
    license = lib.licenses.mit;
  };
}
