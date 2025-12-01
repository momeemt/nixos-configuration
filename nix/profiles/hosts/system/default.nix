{
  pkgs,
  lib,
  siteLib,
  ...
}: {
  imports =
    [
      ./tools
    ]
    ++ lib.optionals siteLib.isDarwin [
      ./defaults
      ./startup
    ];

  system = {
    stateVersion =
      if pkgs.stdenv.isLinux
      then siteLib.stateVersion
      else 6;
  };
}
