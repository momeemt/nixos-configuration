{
  pkgs,
  lib,
  ...
}:
with pkgs.brewCasks;
  lib.optionals pkgs.stdenv.isDarwin [
    angry-ip-scanner
    bitwarden
    brave-browser
    chatgpt
    chatgpt-atlas
    (lib.meta.lowPrio claude)
    discord
    docker-desktop
    element
    figma
    jetbrains-toolbox
    github
    google-chrome
    google-drive
    # (hhkb.overrideAttrs (oldAttrs: {
    #   unpackPhase = "";
    # }))
    httpie-desktop
    # karabiner-elements
    keybase
    keycastr
    # (logitech-g-hub.overrideAttrs (oldAttrs: {
    #   src = pkgs.fetchurl {
    #     url = lib.lists.head oldAttrs.src.urls;
    #     hash = "sha256-Nx2TXDr22KkVVOV0lNI8t/0zCqFc2fjFl9mFWxdQFOw=";
    #   };
    # }))
    # (logitech-options.overrideAttrs (oldAttrs: {
    #   src = pkgs.fetchurl {
    #     url = lib.lists.head oldAttrs.src.urls;
    #     hash = "sha256-qAEdpofRCYk2DAyqIxxSXnxx2qF6rA0Zmbk0s8+1Rqc=";
    #   };
    # }))
    loom
    microsoft-edge
    microsoft-excel
    (lib.meta.hiPrio microsoft-outlook)
    microsoft-powerpoint
    microsoft-teams
    microsoft-word
    notchnook
    notion
    obs
    ollama-app
    readdle-spark
    slack
    spotify
    # synology-drive
    todoist-app
    # unity
    unity-hub
    windows-app
    zoom
  ]
