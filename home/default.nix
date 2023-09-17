{
  cliBundle = { pkgs, ... }: {
    imports = [
      ./aerc
      ./bash
      ./fish
      ./git
      ./gpg
      ./neovim
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
      eza
      fd
      ffmpeg
      findutils
      flexget
      fzf
      gawk
      gcc
      gnumake
      gnused
      graphviz
      htop
      imagemagick
      intel-gpu-tools
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
      nnn
      pass
      pdftk
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
      ack
      act
      berglas
      bfg-repo-cleaner
      black
      cabal-install
      ccls
      clang-tools
      consul
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
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
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
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nomad
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
      semgrep # TODO: Doesn't successfully build yet.
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
      ./calibre
      ./keybase
      ./kitty
      ./mimetypes
      ./mpv
      ./syncthing
      ./user-dirs
    ];

    home.packages = with pkgs; [
      arandr
      brightnessctl
      chromium
      evince
      feh
      firefox
      fontforge-gtk
      gimp
      gnome3.gedit
      gnome3.nautilus
      libnotify
      maim
      paprefs
      pavucontrol
      peek
      simplescreenrecorder
      slack
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
    ];

    home.packages = with pkgs; [
      discord
      puddletag
      signal
      tdesktop
      transmission-qt
      tremotesf
      zotero
    ];
  };

  i3Bundle = { pkgs, specialArgs, ... }: {
    fonts.fontconfig.enable = true;

    imports = [
      ./dunst
      ./i3
      ./i3wsr
      ./picom
      ./polybar
      ./rofi
      ./xbindkeys
    ];

    home.packages = with pkgs; [
      bar-gpu
      bar-loadavg
      bar-vpn
      i3-change-audio
      i3-clear-clipboard
      i3-lock
      i3-pass
      i3-screenshot
      i3-yy

      # plata-theme
      # papirus-icon-theme
      font-awesome_5
      iosevka-bin
      noto-fonts
      noto-fonts-cjk
      roboto
      source-code-pro
      source-sans-pro
    ];
  };
}
