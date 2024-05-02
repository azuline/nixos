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
      coreutils
      curl
      dasel
      decrypt-frieren
      dnsutils
      edit-toc
      exiftool
      fd
      ffmpeg
      file
      # flexget  # Failing in unstable; I don't use it rn so I don't care.
      file-uploader
      findutils
      fx
      fzf
      gawk
      gcc
      ghostscript
      gnumake
      gnused
      graphviz
      htop
      imagemagick
      intel-gpu-tools
      jq
      mediainfo
      mkcert
      mktorrent
      mkvtoolnix
      moreutils
      neofetch
      nix-search-cli
      nmap
      ocrmypdf
      optipng
      opusTools
      p7zip
      (lib.hiPrio parallel-full) # parallel is also part of moreutils
      pass
      pdfgrep
      pdftk
      pngquant
      pinentry
      poetry
      poppler_utils
      procps
      python
      qpdf
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
      tesseract
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
      kube-linter
      kubectl
      levant
      luajitPackages.luacheck
      minikube
      mypy
      nil
      nixpkgs-fmt
      node2nix
      nodePackages.bash-language-server
      nodePackages.eslint
      nodePackages.pnpm
      nodePackages.prettier
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodejs
      ocamlPackages.utop
      ocamlformat
      pgformatter
      pgmigrate
      php83
      php83Packages.composer
      postgresql_13
      protobuf
      protoc-gen-go
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
      vscode-langservers-extracted
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
      discord
      puddletag
      signal
      nicotine-plus
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
      i3-change-audio
      i3-clear-clipboard
      i3-lock
      i3-pass
      i3-screenshot
    ];
  };
}
