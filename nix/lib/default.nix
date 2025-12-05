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
  # genCaHash = path:
  #   import ./genCaHash.nix {
  #     inherit pkgs;
  #     caCertPath = path;
  #   };
in {
  inherit mkK8sMaster mkK8sWorker images publicKeys ip;

  isLinux = lib.hasInfix "linux" system;
  isDarwin = lib.hasInfix "darwin" system;
  githubRepository = {
    url = "github.com/momeemt/config";
    defaultBranch = "develop";
  };
  stateVersion = "25.11";
  k8sCaCertHash = "32b10d3c2eee5440d1d0a884aedc15345daf44047f5e1e94cc0a80c23351b5bf";
}
