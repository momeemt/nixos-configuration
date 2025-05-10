{ pkgs, ...  }:
with pkgs; [
    neofetch
    gh
    ghq
    ripgrep
    eza
    bat
    bottom
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    })
    nixpkgs-review
  ]

