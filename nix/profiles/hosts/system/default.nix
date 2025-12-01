{
  pkgs,
  siteLib,
  ...
}: {
  system = {
    stateVersion =
      if pkgs.stdenv.isLinux
      then siteLib.stateVersion
      else 6;
  };
}
