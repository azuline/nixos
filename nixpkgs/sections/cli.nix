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
    dnsutils
    exa
    fd
    fzf
    graphviz
    imagemagick
    jq
    mediainfo
    neofetch
    # wtf the init.vim isnt working
    # neovim
    nnn
    pass
    pdftk
    procps-ng
    python39Packages.pipx
    ripgrep
    speedtest-cli
    sqlite
    sshfs
    tree
    trash-cli
    weechat
    whois
    tldr
  ];
}
