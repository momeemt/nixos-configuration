{pkgs, ...}: {
  programs.nixvim.plugins.wakatime = {
    enable = true;
    package = pkgs.vimPlugins.vim-wakatime;
  };
}
