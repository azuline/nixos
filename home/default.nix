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
      ./syncthing
      ./tmux
    ];

    home.packages = with pkgs; [
      # flexget  # Failing in unstable; I don't use it rn so I don't care.
      autossh
      bat
      bc
      cmake
      coreutils
      curl
      dasel
      decrypt-frieren
      decrypt-pdf
      dnsutils
      edit-toc
      exiftool
      fd
      ffmpeg
      file
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
      jq
      llm
      mkcert
      mktorrent
      moreutils
      neofetch
      nix-search-cli
      nmap
      ocrmypdf
      openssl
      optipng
      p7zip
      (lib.hiPrio parallel-full) # parallel is also part of moreutils
      pass
      pdfgrep
      pdftk
      pngquant
      poetry
      poppler_utils
      procps
      pstree
      python
      qpdf
      rclone
      rename
      ripgrep
      rsync
      socat
      sox
      speedtest-cli
      sqlite-interactive
      sshfs
      tailnet-switch
      tcpdump
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
      pinentry-curses
      xan
      yq-go
      zip
    ];
  };

  devBundle = { pkgs, ... }: {
    imports = [
      ./direnv
      # ./figma-agent  # Broken.
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
      dotnet-sdk_9
      dune_3
      # gdb  # TODO(revive)
      gitAndTools.delta
      go
      gofumpt
      golangci-lint
      gopls
      biome
      haskell-language-server
      ngrok
      haskellPackages.implicit-hie
      isort
      jdk11
      jujutsu
      just
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
      uv
      nodePackages.pnpm
      nodePackages.prettier
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
      pyright
      # ruff
      rustup
      selene
      semgrep
      tailwindcss-language-server
      shellcheck
      sqlint
      stack
      stylua
      sumneko-lua-language-server
      tokei
      universal-ctags
      vscode-langservers-extracted
      watchman # Needed for tsserver
      wrangler
      yarn
      zig
      zls
    ];
  };

  musicBundle = { pkgs, lib, ... }: {
    imports = [
      ./rose
      ./mpv
    ];

    home.packages = with pkgs; [
      flac
      mediainfo
      mkvtoolnix
      opusTools
      yt-dlp
    ] ++ (if pkgs.stdenv.isLinux then [
      beets
      plexamp
      puddletag
    ] else [ ]);
  };

  guiBundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./kitty
    ];

    home.packages = with pkgs; [
      term-pass
    ];
  };

  linuxGuiBundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./cursor
      ./mimetypes
      ./nsxiv
      ./user-dirs
      ./zathura
    ];

    home.packages = with pkgs; [
      arandr
      brightnessctl
      discord
      gimp
      libnotify
      maim
      paprefs
      pavucontrol
      chromium
      firefox
      peek
      pulseaudio # for pactl
      simplescreenrecorder
      speechd
      tor-browser-bundle-bin
      xbindkeys
      xdotool # For VimTex's forward search.
      xorg.xkill
      xwallpaper
      slack
      vscode
      zoom-us
    ];
  };

  macGuiBundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./aerospace
      ./ghostty
      ./karabiner
    ];
  };

  personalMachineBundle = { pkgs, ... }: {
    imports = [
      ./atelier
    ];

    home.packages = with pkgs; [
      anki
      calibre
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
      bar-ddcutil
      bar-loadavg
      bar-now-playing
      bar-vpn
      i3-clear-clipboard
      i3-lock
      i3-screenshot
    ];
  };
}
