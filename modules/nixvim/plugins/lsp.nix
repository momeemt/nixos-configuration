{pkgs, ...}: {
  plugins.lsp = {
    enable = true;
    keymaps = {
      diagnostic = {
        "<space>e" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
        "<space>q" = "setloclist";
      };
      lspBuf = {
        "gD" = "declaration";
        "gd" = "definition";
        "K" = "hover";
        "gi" = "implementation";
        "<C-k>" = "signature_help";
        "<space>wa" = "add_workspace_folder";
        "<space>wr" = "remove_workspace_folder";
        "<space>D" = "type_definition";
        "<space>rn" = "rename";
        "<space>ca" = "code_action";
        "gr" = "references";
      };
      extra = [
        {
          key = "<space>wl";
          action = {
            __raw = ''
              function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end
            '';
          };
        }
        {
          key = "<space>f";
          action = {
            __raw = ''
              function()
                vim.lsp.buf.format({ async = true })
              end
            '';
          };
          options = {
            noremap = true;
            silent = true;
          };
        }
      ];
    };
    servers = {
      clangd = {
        enable = true;
        package = pkgs.llvmPackages_19.clang-tools;
      };
      denols = {
        enable = true;
        package = pkgs.deno;
        filetypes = [
          "deno.json"
          "deno.jsonc"
        ];
        settings = {
          enable = true;
          suggest = {
            imports = {
              hosts = {
                "https://deno.land" = true;
              };
            };
          };
        };
      };
      dhall_lsp_server = {
        enable = true;
        package = pkgs.dhall-lsp-server;
      };
      lua_ls = {
        enable = true;
        package = pkgs.lua-language-server;
        settings = {
          diagnostics = {
            globals = [
              "vim"
            ];
          };
        };
      };
      nil_ls = {
        enable = true;
        package = pkgs.nil;
        settings = {
          formatting = {
            command = [
              "${pkgs.alejandra}/bin/alejandra"
            ];
          };
        };
      };
      nim_langserver = {
        enable = true;
        package = pkgs.nimlangserver;
      };
      ocamllsp = {
        enable = true;
        package = pkgs.ocamlPackages.ocaml-lsp;
      };
      purescriptls = {
        enable = true;
        package = pkgs.nodePackages.purescript-language-server;
      };
      rust_analyzer = {
        enable = true;
        package = pkgs.rust-analyzer;
        installRustc = true;
        installCargo = true;
      };
      terraformls = {
        enable = true;
        package = pkgs.terraform-ls;
      };
      ts_ls = {
        enable = true;
        package = pkgs.typescript-language-server;
        filetypes = [
          "package.json"
        ];
        extraOptions = {
          single_file_support = false;
        };
      };
      vimls = {
        enable = true;
        package = pkgs.vim-language-server;
      };
      zls = {
        enable = true;
        package = pkgs.zls;
      };
    };
  };
}
