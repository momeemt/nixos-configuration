_final: prev: {
  python311Packages = prev.python311Packages.overrideScope (
    _pyfinal: pyprev: {
      libtmux = pyprev.libtmux.overrideAttrs (oldAttrs: {
        # Additional flaky tests in CI environments
        disabledTests =
          (oldAttrs.disabledTests or [])
          ++ [
            "test_capture_pane"
            "test_capture_pane_end"
            "test_new_window_with_environment"
          ];
      });
    }
  );
}
