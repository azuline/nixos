{
  cliBundle = { pkgs, ... }: {
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.extraConfig = ''
      pinentry-program ${pkgs.pinentry}/bin/pinentry
      default-cache-ttl 14400
      max-cache-ttl 14400
    '';

    imports = [
      ./aerc
      ./bash
      ./fish
      ./git
      ./neovim
      ./readline
      ./tmux
    ];

    home.packages = with pkgs; [
      nix-search-cli
      autossh
      unzip
      woff2
      bat
      beets
      brightnessctl
      bubblewrap
      cmus
      coreutils
      curl
      dasel
      decrypt-zen
      dnsutils
      exa
      fd
      ffmpeg
      findutils
      fzf
      gawk
      gcc # Is this writing some weird nix ld that's half broken?
      gnumake
      rename
      gnused
      graphviz
      htop
      imagemagick
      jq
      tectonic
      libsecret
      mediainfo
      mkcert
      mktorrent
      mkvtoolnix
      monolith
      moreutils
      neofetch
      nmap
      pass
      pdftk
      pinentry
      poetry
      procps
      ripgrep
      rsync
      speedtest-cli
      sqlite-interactive
      sshfs
      termdown
      tomb
      tldr
      trash-cli
      tree
      unixtools.netstat
      unrar
      weechat
      wget
      whois
      wireguard-tools
      wl-clipboard
      xclip
      xsv
      youtube-dl
      yq-go
      zip
    ];
  };

  devBundle = { pkgs, ... }: {
    services.lorri.enable = true;

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
      docker
      levant
      nomad
      consul
      docker-compose
      dune_3
      gdb
      gitAndTools.delta
      go_1_18
      gofumpt
      golangci-lint
      gopls
      google-cloud-sdk
      haskell-language-server
      haskellPackages.implicit-hie
      jdk11
      kind
      kubectl
      kube-linter
      luajitPackages.luacheck
      node2nix
      minikube
      mypy
      ruff
      pgformatter
      nixpkgs-fmt
      nodejs
      nodePackages.eslint
      nodePackages.eslint_d
      nodePackages.pnpm
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      ocamlformat
      ocamlPackages.utop
      php80
      php80Packages.composer
      postgresql_13
      protoc-gen-go
      python
      rnix-lsp
      protobuf
      selene
      shellcheck
      # semgrep # TODO: Doesn't successfully build yet.
      sqlint
      stack
      stylua
      sumneko-lua-language-server
      universal-ctags
      watchman # Needed for tsserver
      yarn
    ];
  };

  guiBundle = { pkgs, specialArgs, ... }: {
    services.syncthing.enable = true;

    imports = [
      ./calibre
      ./keybase
      ./kitty
      ./mpv
      ./user-dirs
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # Look in ~/.nix-profile/share/applications
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
        "x-scheme-handler/mailto" = [ "aerc.desktop" ];
        "x-www-browser" = [ "firefox.desktop" ];
        "image/png" = [ "feh.desktop" ];
      };
    };

    home.packages = with pkgs; [
      arandr
      discord
      feh
      gimp
      gnome3.gedit
      grim
      libnotify
      maim
      peek
      signal
      slack
      fontforge-gtk
      xdotool # For VimTex's forward search.
      slurp
      spotify
      tdesktop
      transmission-qt
      xorg.xkill
      zathura
    ] ++ (
      if specialArgs.sys.nixos then [
        firefox
        zoom-us
        zotero
        gnome3.nautilus
      ] else [ ]
    );
  };

  i3Bundle = { pkgs, specialArgs, ... }: {
    imports = [
      ./dunst
      ./i3
      ./i3wsr
      ./picom
      ./polybar
      ./rofi
    ];

    home.packages = with pkgs; [
      bar-gpu
      bar-loadavg
      bar-vpn
      i3-change-audio
      i3-clear-clipboard
      (if specialArgs.sys.nixos then i3-lock-nixos else i3-lock-debian)
      i3-pass
      i3-screenshot
      i3-yy
    ];
  };

  swayBundle = { pkgs, ... }: {
    imports = [
      ./dunst
      ./rofi
      ./sway
      ./swaylock
      ./waybar
    ];

    home.packages = with pkgs; [
      bar-vpn
      sway-clear-clipboard
      sway-pass
      sway-yy
      swayidle
      swaywsr
    ];
  };

  themeBundle = { pkgs, ... }: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # plata-theme
      # papirus-icon-theme

      font-awesome_5
      iosevka-bin
      roboto
      source-code-pro
      source-sans-pro
      noto-fonts
      noto-fonts-cjk
    ];
  };
}
