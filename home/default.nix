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
      autossh
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
      # gcc  # Is this writing some weird nix ld that's half broken?
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
      sqlcheck
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
      gnome3.nautilus
      grim
      libnotify
      maim
      peek
      signal
      slack
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
