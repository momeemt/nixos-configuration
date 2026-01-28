_final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (_pyfinal: pyprev: {
        libtmux = pyprev.libtmux.overrideAttrs (_oldAttrs: {
          # Tests are flaky in CI environments
          doCheck = false;
        });
      })
    ];
}
