{
  lib,
  siteLib,
  ...
}: {
  system.tools =
    lib.optionalAttrs siteLib.isDarwin {
      darwin-option.enable = true;
      darwin-rebuild.enable = true;
      darwin-uninstaller.enable = true;
      darwin-version.enable = true;
    }
    // lib.optionalAttrs siteLib.isLinux {
      nixos-option.enable = true;
      nixos-rebuild.enable = true;
      nixos-install.enable = true;
      nixos-generate-config.enable = true;
      nixos-enter.enable = true;
      nixos-build-vms.enable = true;
      nixos-version.enable = true;
    };
}
