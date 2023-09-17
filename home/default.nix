{
  cliBundle = { pkgs, ... }: {
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.extraConfig = ''
      pinentry-program ${pkgs.pinentry}/bin/pinentry
      default-cache-ttl 14400
      max-cache-ttl 14400
    '';
    services.ssh-agent.enable = true;

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
      autossh
      bat
      beets
      bubblewrap
      cmus
      intel-gpu-tools
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
      pinentry
      poetry
      procps
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
      rclone
      wget
      whois
      wireguard-tools
      wl-clipboard
      woff2
      xclip
      xsv
      # yt-dlp  # old version; TODO: Pull latest from github
      nnn
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
      dprint
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
      devenv
      docker-compose
      dune_3
      gdb
      gitAndTools.delta
      go
      gofumpt
      golangci-lint
      gopls
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
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
      pgmigrate
      php83
      php83Packages.composer
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
      zig
      zls
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
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
        "x-scheme-handler/mailto" = [ "aerc.desktop" ];
        "x-www-browser" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "image/png" = [ "feh.desktop" ];
        "image/jpeg" = [ "feh.desktop" ];
      };
    };

    home.packages = with pkgs; [
      brightnessctl
      arandr
      feh
      gimp
      gnome3.gedit
      libnotify
      maim
      peek
      slack
      fontforge-gtk
      xdotool # For VimTex's forward search.
      paprefs
      pavucontrol
      spotify
      xbindkeys
      xorg.xkill
      chromium
      firefox
      zoom-us
      gnome3.nautilus
      simplescreenrecorder
      evince
    ];
  };

  personalMachineBundle = { pkgs, ... }: {
    imports = [
      ./atelier
    ];
    home.packages = with pkgs; [
      puddletag
      zotero
      discord
      signal
      tdesktop
      transmission-qt
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
      vscode
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
      roboto
      source-code-pro
      source-sans-pro
      noto-fonts
      noto-fonts-cjk
    ];
  };
}
