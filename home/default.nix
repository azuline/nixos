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
      flexget
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
      (lib.setPrio 15 gcc) # it conflicts with clang
      ghostscript
      gnumake
      gnused
      graphviz
      hexyl
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
      biome
      black
      cabal-install
      ccls
      clang
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
      haskell-language-server
      haskellPackages.implicit-hie
      jdk11
      jujutsu
      just
      kind
      kube-linter
      kubectl
      levant
      luajitPackages.luacheck
      minikube
      mise
      mypy
      namespace-cli
      nil
      nixpkgs-fmt
      node2nix
      nodePackages.bash-language-server
      nodePackages.eslint
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
      # php83Packages.composer  # Temporary because LICENSE was erroneously added here and in prettier so they conflict paths.
      postgresql_13
      protobuf
      protoc-gen-go
      pyright
      ruff
      rustup
      selene
      semgrep
      shellcheck
      sqlint
      stack
      stylua
      sumneko-lua-language-server
      tailwindcss-language-server
      tokei
      universal-ctags
      uv
      vscode-langservers-extracted
      watchman # Needed for tsserver
      # wrangler  # Temporary because LICENSE was erroneously added here and in prettier so they conflict paths.
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
      ./zed
    ];

    home.packages = with pkgs; [
      arandr
      brightnessctl
      chromium
      discord
      evince
      firefox
      gimp
      libnotify
      maim
      nautilus
      paprefs
      pavucontrol
      peek
      pulseaudio # for pactl
      simplescreenrecorder
      slack
      speechd
      tor-browser-bundle-bin
      vscode.fhs
      xbindkeys
      xdotool # For VimTex's forward search.
      xorg.xkill
      xwallpaper
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
    imports = [ ];

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
      i3-yy
    ];
  };
}
