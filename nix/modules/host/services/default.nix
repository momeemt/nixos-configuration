{
  lib,
  siteLib,
  ...
}: {
  imports = lib.optionals siteLib.isDarwin [
    ./set-wallpapers
  ];
}
