{
  pkgs,
  inputsFrom,
}:
pkgs.mkShell {
  inherit inputsFrom;
  buildInputs = with pkgs; [
    kubectl
    kubernetes-helm
  ];
}
