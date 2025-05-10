{
  pkgs,
  ...
}: {
  imports = [
    ./nix/alacritty.nix
    ./nix/direnv.nix
    ./nix/git.nix
    ./nix/neovim.nix
    ./nix/starship.nix
    ./nix/tmux.nix
    ./nix/zsh.nix
  ];

  home = {
    username = "momeemt";
    homeDirectory = "/Users/momeemt";
    stateVersion = "24.11";
    packages = with pkgs; [
      ripgrep
      neofetch
      eza
      bat
      bottom
      home-manager
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };
}
