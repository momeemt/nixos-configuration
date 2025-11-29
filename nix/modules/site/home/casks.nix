{
  pkgs,
  lib,
  ...
}: let
  google-chrome = pkgs.brewCasks.google-chrome.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = lib.lists.head oldAttrs.src.urls;
      hash = "sha256-3tGFRcWoAu8EUMRpKWBfKRBsBuJtVl2mZurujkmiUcA=";
    };
  });
  google-drive = pkgs.brewCasks.google-drive.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = lib.lists.head oldAttrs.src.urls;
      hash = "sha256-zrFs+5BWqjSzvxrQFcR1NlGes8Mhp6OLdx6sjYFuZGY=";
    };
    nativeBuildInputs = with pkgs; (oldAttrs.nativeBuildInputs or []) ++ [pbzx];
    unpackPhase = ''
      set -euo pipefail
      undmg "$src"
      xar -xf GoogleDrive.pkg GoogleDrive_arm64.pkg/Payload
      pbzx -n GoogleDrive_arm64.pkg/Payload | cpio -idm
    '';
  });
  microsoft-teams = pkgs.brewCasks.microsoft-teams.overrideAttrs (oldAttrs: {
    nativeBuildInputs = with pkgs; (oldAttrs.nativeBuildInputs or []) ++ [pbzx];
    unpackPhase = ''
      set -euo pipefail
      xar -xf "$src" MicrosoftTeams_app.pkg/Payload
      pbzx -n MicrosoftTeams_app.pkg/Payload | cpio -idm
    '';
  });
  spotify = pkgs.brewCasks.spotify.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = lib.lists.head oldAttrs.src.urls;
      hash = "sha256-gMPLn/QMbbwrlorPRyH9GACqi4jmunfnnMc4AEvyIMU=";
    };
  });
  unity-hub = pkgs.brewCasks.unity-hub.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = lib.lists.head oldAttrs.src.urls;
      hash = "sha256-sj1ZdeVk/p5ZQfR75HMDVYnmAPzcyYIAFaRYXQPZK2s=";
    };
  });
  windows-app = pkgs.brewCasks.windows-app.overrideAttrs (oldAttrs: {
    unpackPhase = ''
      set -euo pipefail
      xar -xf "$src" com.microsoft.rdc.macos.pkg/Payload
      gzip -d < com.microsoft.rdc.macos.pkg/Payload | cpio -idm
    '';
    nativeBuildInputs = with pkgs; (oldAttrs.nativeBuildInputs or []) ++ [cpio gzip];
  });
in
  with pkgs.brewCasks;
    lib.optionals pkgs.stdenv.isDarwin [
      # adobe-creative-cloud
      angry-ip-scanner
      bitwarden
      brave-browser
      canva
      chatgpt
      chatgpt-atlas
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
      # tailscale-app
      todoist-app
      # unity
      unity-hub
      windows-app
      zoom
    ]
