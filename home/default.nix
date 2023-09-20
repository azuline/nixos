{
  cliBundle = { pkgs, ... }: {
    imports = [
      ./aerc
      ./bash
      ./fish
      ./git
      ./gpg
      ./neovim
      ./nnn
      ./readline
      ./ssh
      ./tmux
    ];

    home.packages = with pkgs; [
      autossh
      bat
      beets
      bubblewrap
      cmus
      coreutils
      curl
      dasel
      decrypt-zen
      dnsutils
      exiftool
      eza
      fd
      ffmpeg
      file
      file-uploader
      findutils
      flexget
      fx
      fzf
      gawk
      gcc
      gnumake
      gnused
      graphviz
      htop
      imagemagick
      intel-gpu-tools
      jhead
      jq
      libsecret
      mediainfo
      mkcert
      mktorrent
      mkvtoolnix
      monolith
      moreutils
      neofetch
      nix-search-cli
      nmap
      pass
      pdftk
      perl536Packages.FileMimeInfo
      pinentry
      poetry
      procps
      rclone
      rename
      ripgrep
      rsync
      speedtest-cli
      sqlite-interactive
      sshfs
      tectonic
      termdown
      tomb
      trash-cli
      tree
      unixtools.netstat
      unrar
      unzip
      w3m
      wget
      whois
      wireguard-tools
      wl-clipboard
      woff2
      xclip
      xsv
      yq-go
      yt-dlp
      zip
    ];
  };

  devBundle = { pkgs, ... }: {
    imports = [
      ./direnv
      ./gh
      ./ghc
    ];

    home.packages = with pkgs; [
      act
      bfg-repo-cleaner
      black
      cabal-install
      ccls
      clang-tools
      devenv
      docker
      docker-compose
      dprint
      dune_3
      gdb
      gitAndTools.delta
      go
      gofumpt
      golangci-lint
      gopls
      haskell-language-server
      haskellPackages.implicit-hie
      jdk11
      kind
      kubectl
      kube-linter
      levant
      luajitPackages.luacheck
      minikube
      mypy
      nixpkgs-fmt
      node2nix
      nodejs
      nodePackages.eslint
      nodePackages.eslint_d
      nodePackages.pnpm
      nodePackages.prettier
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      ocamlformat
      ocamlPackages.utop
      pgformatter
      pgmigrate
      php83
      php83Packages.composer
      postgresql_13
      protobuf
      protoc-gen-go
      python
      rnix-lsp
      ruff
      selene
      semgrep
      shellcheck
      sqlint
      stack
      stylua
      sumneko-lua-language-server
      tokei
      universal-ctags
      watchman # Needed for tsserver
      yarn
      zig
      zls
    ];
  };

  guiBundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./kitty
      ./mimetypes
      ./mpv
      ./nsxiv
      ./user-dirs
    ];

    home.packages = with pkgs; [
      adoptopenjdk-icedtea-web # Run jlnp files.
      arandr
      brightnessctl
      chromium
      evince
      feh
      firefox
      fontforge-gtk
      gimp
      libnotify
      maim
      paprefs
      pavucontrol
      peek
      pulseaudio # for pactl
      simplescreenrecorder
      slack
      speechd
      spotify
      vscode
      xbindkeys
      xdotool # For VimTex's forward search.
      xorg.xkill
      zoom-us
    ];
  };

  personalMachineBundle = { pkgs, ... }: {
    imports = [
      ./atelier
      ./calibre
      ./keybase
      ./syncthing
    ];

    home.packages = with pkgs; [
      discord
      puddletag
      signal
      tdesktop
      tremotesf
      zotero
    ];
  };

  i3Bundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./dunst
      ./fonts
      ./i3
      ./i3wsr
      ./picom
      ./polybar
      ./rofi
      ./theme
      ./xbindkeys
    ];

    home.packages = with pkgs; [
      bar-gpu
      bar-loadavg
      bar-vpn
      i3-aerc
      i3-change-audio
      i3-clear-clipboard
      i3-lock
      i3-pass
      i3-screenshot
      i3-yy
    ];
  };
}
