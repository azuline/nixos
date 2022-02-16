{ pkgs, ... }:

{
  programs.fish.enable = true;
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.extraConfig = ''
    pinentry-program /usr/bin/pinentry-gtk-2
  '';

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
    wl-clipboard
    xclip
    xss-lock
  ];
}
