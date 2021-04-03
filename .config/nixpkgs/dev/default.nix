{ pkgs, ... }:

{
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.fish.enable = true;

  programs.go.enable = true;

  imports = [
    ./tmux
  ];

  home.packages = with pkgs; [
    act
    autossh
    jq
    fd
    bat
    fzf
    nnn
    rnix-lsp
  ];
}
