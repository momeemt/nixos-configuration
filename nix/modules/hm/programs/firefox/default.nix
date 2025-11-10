{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    policies = {
      ExtensionSettings = with pkgs.firefox-addons; {
        ${bitwarden.addonId} = {
          installation_mode = "force_installed";
          default_area = "navbar";
          private_browsing = true;
        };
        ${vimium.addonId} = {
          installation_mode = "force_installed";
          default_area = "navbar";
          private_browsing = true;
        };
      };
    };

    profiles.momeemt = let
      duck-duck-go-id = "ddg";
    in {
      id = 0;
      isDefault = true;

      settings = {
        "extensions.autoDisableScopes" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;

      extensions = {
        force = true;
        packages = with pkgs.firefox-addons; [
          bitwarden
          vimium
        ];
        # settings = with pkgs.firefox-addons; {
        #   ${bitwarden.addonId}.settings = {
        #
        #   };
        # };
      };

      search = {
        force = true;
        default = duck-duck-go-id;
        privateDefault = duck-duck-go-id;
        order = [
          duck-duck-go-id
          "nixpkgs-packages"
          "nixos-wiki"
          "github"
        ];
        engines = {
          nixpkgs-packages = {
            name = "NixOS/nixpkgs Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [{
              template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
            }];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" ];
          };
          github = {
            name = "GitHub";
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://github.githubassets.com/favicons/favicon.svg";
            definedAliases = ["@gh"];
          };
          bing.metaData.hidden = true;
        };
      };
    };
  };
}
