{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../profiles/nixvim
    inputs.tmux-nix.homeModules.tmux-nix
    ../../profiles/tmux-nix
    ../../profiles/hm/nix
    ../../profiles/hm/editorconfig
    ../../profiles/hm/programs
    ../../profiles/hm/programs/ssh
    ../../profiles/hm/services
    ../../profiles/hm/sops
    ../../profiles/hm/wakatime
    ../../profiles/hm/wayland/windowManager/sway
    ../../profiles/site/home
  ];

  site.home = {
    username = "momeemt";
    groups.linuxDesktop = true;
    extraPackages = with pkgs; [
      quartus-prime-lite
    ];
  };

  programs.git = {
    signing = {
      # `gpg --list-secret-keys --keyid-format LONG`
      key = "86F8F50B69A94DE2";
      signByDefault = true;
    };
  };
}
