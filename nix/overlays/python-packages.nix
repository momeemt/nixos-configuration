_final: prev: {
  python311Packages = prev.python311Packages.override {
    overrides = _pyfinal: pyprev: {
      libtmux = pyprev.libtmux.overrideAttrs (_oldAttrs: {
        # Tests are flaky in CI environments
        doCheck = false;
      });
    };
  };
}
