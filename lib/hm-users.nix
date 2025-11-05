{inputs}: {users}: {config, ...}: let
  normalize = spec:
    if builtins.isPath spec || builtins.isString spec
    then (import spec)
    else spec;
  hmUsers = builtins.mapAttrs (_: spec: normalize spec) users;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      systemConfig = config;
    };
    backupFileExtension = "hm-bak";
    users = hmUsers;
  };
}
