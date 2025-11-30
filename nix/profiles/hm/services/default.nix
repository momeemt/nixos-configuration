{siteLib, ...}: {
  imports =
    if siteLib.isLinux
    then [./linux.nix]
    else [./darwin.nix];
}
