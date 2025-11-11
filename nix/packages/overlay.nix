self: super: let
  pkgs = super;
  subscribePackages = import ./subscribe {inherit pkgs;};
in {
  myPackages = {
    destroy-all-vm = import ./destroy-all-vm {inherit pkgs;};
    encrypt-secrets = import ./encrypt-secrets {inherit pkgs;};
    ncp = import ./ncp {inherit pkgs;};
    quitapp = import ./quitapp {inherit pkgs;};
    switch-config-branch = import ./switch-config-branch {inherit pkgs;};
    updatekeys-secrets = import ./updatekeys-secrets {inherit pkgs;};
    ok = subscribePackages.ok;
    ng = subscribePackages.ng;
    subscribe = subscribePackages.subscribe;
  };
}
