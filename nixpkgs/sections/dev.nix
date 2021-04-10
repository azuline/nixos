{ pkgs, ... }:

{
  # programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  programs.fish.enable = true;
  programs.gpg.enable = true;

  imports = [
    ../pkgs/haskell
    ../pkgs/git
    ../pkgs/tmux
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
