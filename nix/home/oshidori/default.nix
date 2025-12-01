{inputs, ...}: {
  imports = [
    ../../profiles/nixvim
    inputs.tmux-nix.homeModules.tmux-nix
    ../../profiles/tmux-nix
    ../../profiles/hm/nix
    ../../profiles/hm/editorconfig
    ../../profiles/hm/programs
    ../../profiles/hm/sops
    ../../profiles/hm/wakatime
  ];

  site.home = {
    username = "momeemt";
    groups.linuxDesktop = true;
  };
}
