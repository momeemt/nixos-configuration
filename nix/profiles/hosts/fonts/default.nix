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
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    dejavu_fonts
    nerd-fonts.jetbrains-mono
  ];
}
