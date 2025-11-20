{inputs}: {
  users,
  siteLib,
  system,
}: {config, ...}: let
  normalize = spec:
    if builtins.isPath spec || builtins.isString spec
    then (import spec)
    else spec;
  hmUsers = builtins.mapAttrs (_: normalize) users;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs siteLib system;
      systemConfig = config;
    };
    backupFileExtension = "hm-bak";
    users = hmUsers;
    sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
  };
}
