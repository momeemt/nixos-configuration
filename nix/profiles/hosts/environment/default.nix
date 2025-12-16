{
  pkgs,
  lib,
  siteLib,
  ...
}: {
  imports =
    lib.optionals siteLib.isLinux [
      ./nixos
    ]
    ++ lib.optionals siteLib.isDarwin [
      ./darwin
    ];

  environment = {
    enableAllTerminfo = false;

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enableCompletion
    pathsToLink = [
      "/share/bash-completion"
      "/share/zsh"
    ];

    shells = with pkgs; [
      bash
      zsh
    ];
  };
}
