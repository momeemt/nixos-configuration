{
  pkgs,
  lib,
  system,
}: let
  mkK8sMaster = args:
    import ./mkK8sMaster (
      args // {inherit lib;}
    );
  mkK8sWorker = args:
    import ./mkK8sWorker (
      args // {inherit lib;}
    );
  images = import ./images.nix {inherit pkgs;};
  publicKeys = import ./publicKeys.nix;
  ip = import ./ip.nix;
  genCaHash = path:
    import ./genCaHash.nix {
      inherit pkgs;
      caCertPath = path;
    };
in {
  inherit mkK8sMaster mkK8sWorker images publicKeys ip genCaHash;

  isLinux = lib.hasInfix "linux" system;
  isDarwin = lib.hasInfix "darwin" system;
  githubRepository = {
    url = "github.com/momeemt/config";
    defaultBranch = "develop";
  };
}
