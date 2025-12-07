_final: prev: let
  pkgs = prev;
  subscribePackages = import ../packages/subscribe {inherit pkgs;};
in {
  destroy-all-vm = import ../packages/destroy-all-vm {inherit pkgs;};
  encrypt-secrets = import ../packages/encrypt-secrets {inherit pkgs;};
  ncp = import ../packages/ncp {inherit pkgs;};
  quitapp = import ../packages/quitapp {inherit pkgs;};
  switch-config-branch = import ../packages/switch-config-branch {inherit pkgs;};
  updatekeys-secrets = import ../packages/updatekeys-secrets {inherit pkgs;};
  xdg-compliance-checker = import ../packages/xdg-compliance-checker {inherit pkgs;};
  inherit (subscribePackages) ok ng subscribe;
  karabiner-elements_14-13-0 = import ../packages/karabiner-elements_14-13-0 {inherit pkgs;};
}
