{ pkgs, ... }:

{
  # programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  programs.fish.enable = true;

  imports = [
    ./haskell
    ./tmux
  ];

  home.packages = with pkgs; [
    act
    autossh
    bat
    docker-compose
    fd
    fzf
    jq
    nnn
    rnix-lsp
    sqlite
  ];
}
