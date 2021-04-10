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
    fd
    fzf
    jq
    neovim
    nnn
    python39Packages.pipx
    speedtest-cli
    sqlite
    trash-cli
  ];
}