{
  pkgs,
  lib,
  siteLib,
  ...
}: {
  imports = lib.optionals siteLib.isDarwin [
    ./defaults
  ];

  system = {
    stateVersion =
      if pkgs.stdenv.isLinux
      then siteLib.stateVersion
      else 6;
  };
}
