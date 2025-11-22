{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/nixvim
    inputs.tmux-nix.homeModules.tmux-nix
    ../../modules/tmux-nix
    ../../modules/hm/nix
    ../../modules/hm/editorconfig
    ../../modules/hm/programs
    ../../modules/hm/programs/ssh
    ../../modules/hm/services
    ../../modules/hm/sops
    ../../modules/hm/wakatime
    ../../modules/site/home
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
