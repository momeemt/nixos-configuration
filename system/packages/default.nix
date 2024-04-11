{ pkgs, ...  }:
with pkgs; [
    neofetch
    gh
    ripgrep
    eza
    bat
    bottom
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    })
  ]

