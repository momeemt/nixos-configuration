{
  pkgs,
  lib,
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
in {
  inherit mkK8sMaster mkK8sWorker images;
}
