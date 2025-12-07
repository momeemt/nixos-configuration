{
  pkgs,
  inputsFrom,
}:
pkgs.mkShell {
  inherit inputsFrom;
  buildInputs = with pkgs; [
    (python3.withPackages
      (ps:
        with ps; [
          (pandas.overridePythonAttrs (_: {
            doCheck = false;
          }))
          matplotlib
        ]))
  ];
}
