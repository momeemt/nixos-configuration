{
  pkgs,
  lib,
  siteLib,
  ...
}: {
  imports = lib.optionals siteLib.isLinux [
    ./nixos.nix
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-extra
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    dejavu_fonts
    nerd-fonts.jetbrains-mono
  ];
}
