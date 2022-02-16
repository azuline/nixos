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
    brightnessctl
    curl
    dnsutils
    dolt
    exa
    fd
    fzf
    graphviz
    imagemagick
    jq
    mediainfo
    mkvtoolnix
    neofetch
    # Broken with some plugins due to missing libc++.
    neovim
    nnn
    pass
    pdftk
    procps-ng
    python39Packages.pipx
    python39Packages.shodan
    ripgrep
    rsync
    speedtest-cli
    sqlite-interactive
    sshfs
    tldr
    trash-cli
    tree
    unrar
    weechat
    wget
    whois
    xclip
    xss-lock
  ];
}
