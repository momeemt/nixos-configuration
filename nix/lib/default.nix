{
  pkgs,
  lib,
  system,
}: let
  mkK8sMaster = args:
    import ./mkK8sMaster.nix (
      args // {inherit lib;}
    );
  mkK8sWorker = args:
    import ./mkK8sWorker.nix (
      args // {inherit lib;}
    );
  images = import ./images.nix {inherit pkgs;};
  publicKeys = import ./publicKeys.nix;
in {
  inherit mkK8sMaster mkK8sWorker images publicKeys;

  isLinux = lib.hasInfix "linux" system;
  isDarwin = lib.hasInfix "darwin" system;
}
