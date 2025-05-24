{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      tobiasalthoff.atom-material-theme
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      hediet.vscode-drawio
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      kamadorueda.alejandra
      vscodevim.vim
      nvarner.typst-lsp
      wakatime.vscode-wakatime
    ];
  };
}
