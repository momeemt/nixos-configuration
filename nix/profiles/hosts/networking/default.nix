{
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
}
