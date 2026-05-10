_final: prev: {
  brewCasks =
    prev.brewCasks
    // {
      google-chrome = prev.brewCasks.google-chrome.overrideAttrs (oldAttrs: {
        src = prev.fetchurl {
          url = prev.lib.lists.head oldAttrs.src.urls;
          hash = "sha256-Kxt8MrW5ANGAID0L9B/dTA56iE1E+AFp3ym1wqKrqvE=";
        };
      });
      google-drive = prev.brewCasks.google-drive.overrideAttrs (oldAttrs: {
        src = prev.fetchurl {
          url = prev.lib.lists.head oldAttrs.src.urls;
          hash = "sha256-fhEqR2cBPuTdbFxdeiIt96yJkVxpxLsuWpHCP9leF84=";
        };
        nativeBuildInputs = with prev; (oldAttrs.nativeBuildInputs or []) ++ [pbzx];
        unpackPhase = ''
          set -euo pipefail
          undmg "$src"
          xar -xf GoogleDrive.pkg GoogleDrive_arm64.pkg/Payload
          pbzx -n GoogleDrive_arm64.pkg/Payload | cpio -idm
        '';
      });
      keybase = prev.brewCasks.keybase.overrideAttrs (oldAttrs: {
        src = prev.fetchurl {
          url = prev.lib.lists.head oldAttrs.src.urls;
          hash = "sha256-OqjZtcCBHjBcF4ezKBaQQjt4e0huD5mOj1tMPtvo4N0=";
        };
      });
      microsoft-teams = prev.brewCasks.microsoft-teams.overrideAttrs (oldAttrs: {
        nativeBuildInputs = with prev; (oldAttrs.nativeBuildInputs or []) ++ [pbzx];
        unpackPhase = ''
          set -euo pipefail
          xar -xf "$src" MicrosoftTeams_app.pkg/Payload
          pbzx -n MicrosoftTeams_app.pkg/Payload | cpio -idm
        '';
      });
      spotify = prev.brewCasks.spotify.overrideAttrs (oldAttrs: {
        src = prev.fetchurl {
          url = prev.lib.lists.head oldAttrs.src.urls;
          hash = "sha256-cslyAkpAXsVvIfx7tsDpDxnSjidH2uHCeFBq3pXFaMo=";
        };
      });
      unity-hub = prev.brewCasks.unity-hub.overrideAttrs (oldAttrs: {
        src = prev.fetchurl {
          url = prev.lib.lists.head oldAttrs.src.urls;
          hash = "sha256-fVGOxJu7esppxWQ+N8vb2BNphPgn0sUf+oIDF7Gx/Wk=";
        };
      });
      windows-app = prev.brewCasks.windows-app.overrideAttrs (oldAttrs: {
        unpackPhase = ''
          set -euo pipefail
          xar -xf "$src" com.microsoft.rdc.macos.pkg/Payload
          gzip -d < com.microsoft.rdc.macos.pkg/Payload | cpio -idm
        '';
        nativeBuildInputs = with prev; (oldAttrs.nativeBuildInputs or []) ++ [cpio gzip];
      });
    };
}
