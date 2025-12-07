{
  pkgs,
  inputsFrom,
}:
pkgs.mkShell {
  inherit inputsFrom;
  buildInputs = with pkgs; [
    (python314.withPackages
      (ps:
        with ps; [
          pandas
          matplotlib
        ]))
  ];
}
