{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      tobiasalthoff.atom-material-theme
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      hediet.vscode-drawio
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      kamadorueda.alejandra
      vscodevim.vim
      wakatime.vscode-wakatime
    ];
  };
}
