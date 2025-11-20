{config, ...}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      cache_dir = "${config.xdg.cacheHome}/direnv";
    };
  };
}
