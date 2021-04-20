{ pkgs, ... }:

{
  programs.fish.enable = true;
  programs.gpg.enable = true;

  imports = [
    ../pkgs/git
    ../pkgs/tmux
  ];

  home.packages = with pkgs; [
    autossh
    bat
    exa
    fd
    fzf
    graphviz
    jq
    neovim
    nnn
    pdftk
    procps-ng
    python39Packages.pipx
    speedtest-cli
    sqlite
    trash-cli
  ];
}
