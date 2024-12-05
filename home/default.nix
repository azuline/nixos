{
  cliBundle = { pkgs, ... }: {
    imports = [
      ./aerc
      ./bash
      ./fish
      ./git
      ./gpg
      ./neovim
      # ./nnn  # TODO(revive)
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
      mediainfo
      mkcert
      mktorrent
      mkvtoolnix
      moreutils
      neofetch
      nix-search-cli
      nmap
      ocrmypdf
      openssl
      optipng
      opusTools
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
      xsv
      yq-go
      yt-dlp
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
      dotnet-sdk_8
      dprint
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
      ruff
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
      yarn
      zig
      zls
    ];
  };

  guiBundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./kitty
      ./mpv
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

  personalMachineBundle = { pkgs, ... }: {
    imports = [
      ./atelier
      ./rose
    ];

    home.packages = with pkgs; [
      anki
      beets
      calibre
      puddletag
      signal
      mkchromecast
      nicotine-plus
      tailnet-switch
      tdesktop
      tremotesf
      zotero
      plex
      plexamp
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
      i3-clear-clipboard
      i3-lock
      i3-screenshot
    ];
  };
}
