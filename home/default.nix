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
      bc
      beets
      bubblewrap
      coreutils
      curl
      dasel
      decrypt-frieren
      dnsutils
      exiftool
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
      ocrmypdf
      opusTools
      p7zip
      pass
      pdftk
      perl536Packages.FileMimeInfo
      pinentry
      poetry
      procps
      python
      rclone
      rename
      ripgrep
      rsync
      socat
      speedtest-cli
      sqlite-interactive
      sshfs
      tectonic
      termdown
      tree
      unixtools.netstat
      unrar
      trash-cli
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
      docker
      docker-compose
      dotnet-sdk_8
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
      isort
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
      rnix-lsp
      ruff
      ruff-lsp
      rustup
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

  # TODO: Split this up into X11 and GUI apps.
  guiBundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./kitty
      ./mimetypes
      ./mpv
      ./nsxiv
      ./user-dirs
      ./zathura
    ];

    home.packages = with pkgs; [
      adoptopenjdk-icedtea-web # Run jlnp files.
      anki
      arandr
      brightnessctl
      chromium
      firefox
      fontforge-gtk
      gimp
      kdocker
      libnotify
      maim
      paprefs
      pavucontrol
      peek
      pulseaudio # for pactl
      screenkey
      simplescreenrecorder
      slack
      speechd
      tor-browser-bundle-bin
      vscode
      xbindkeys
      xdotool # For VimTex's forward search.
      xorg.xkill
      xwallpaper
      zoom-us
    ];
  };

  personalMachineBundle = { pkgs, ... }: {
    imports = [
      ./atelier
      ./syncthing
      ./rose
    ];

    home.packages = with pkgs; [
      calibre
      bazecor
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
      bar-now-playing
      bar-vpn
      i3-aerc
      i3-change-audio
      i3-clear-clipboard
      i3-lock
      i3-pass
      i3-screenshot
    ];
  };
}
