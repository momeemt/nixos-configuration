{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./highlight
    ./keymaps
    ./opts
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    enableMan = true;
    enablePrintInit = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraConfigLua = builtins.readFile ./init.lua;
  };
}
