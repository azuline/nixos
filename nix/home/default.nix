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
      ./fish
      ./git
      ./neovim
      ./readline
      ./tmux
    ];

    home.packages = with pkgs; [
      autossh
      bashInteractive
      bat
      beets
      brightnessctl
      cmus
      coreutils
      curl
      dasel
      dnsutils
      exa
      fd
      ffmpeg
      findutils
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
      xss-lock
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
      docker-compose
      dune_3
      gdb
      gitAndTools.delta
      gitAndTools.gh
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
      minikube
      mypy
      nixpkgs-fmt
      nodejs
      nodePackages.eslint
      nodePackages.eslint_d
      nodePackages.pnpm
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      ocamlformat
      # ocamlformat-rpc-lib # TODO: Might need this.
      ocamlPackages.utop
      php80
      php80Packages.composer
      postgresql_13
      python
      rnix-lsp
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

  guiBundle = { pkgs, ... }: {
    services.syncthing.enable = true;

    imports = [
      ./calibre
      ./keybase
      ./kitty
      ./mpv
      ./user-dirs
    ];

    home.packages = with pkgs; [
      arandr
      discord
      feh
      firefox
      gimp
      gnome3.gedit
      gnome3.nautilus
      grim
      libnotify
      maim
      signal
      slack
      slurp
      spotify
      tdesktop
      transmission-qt
      xorg.xkill
      zathura
      zoom-us
      zotero
    ];
  };

  i3Bundle = { pkgs, ... }: {
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
      xss-lock
      i3lock-color
      i3-change-audio
      i3-clear-clipboard
      i3-lock
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
