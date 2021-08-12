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
    berglas
    brightnessctl
    curl
    dnsutils
    exa
    fd
    fzf
    google-cloud-sdk
    graphviz
    imagemagick
    jq
    mediainfo
    neofetch
    neovim
    nnn
    pass
    pdftk
    procps-ng
    python39Packages.pipx
    ripgrep
    rsync
    speedtest-cli
    sqlite
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
    python39Packages.shodan
  ];
}
