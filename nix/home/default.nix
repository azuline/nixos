{
  cliBundle = { pkgs, ... }: {
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.extraConfig = ''
      pinentry-program /usr/bin/pinentry-gtk-2
      default-cache-ttl 14400
      max-cache-ttl 14400
    '';

    imports = [
      ./fish
      ./git
      ./neovim
      ./readline
      ./tmux
    ];

    home.packages = with pkgs; [
      autossh
      bat
      bash
      beets
      brightnessctl
      cmus
      coreutils
      curl
      dnsutils
      exa
      fd
      ffmpeg
      findutils
      fzf
      gawk
      gnumake
      gnused
      graphviz
      imagemagick
      jq
      mediainfo
      mktorrent
      mkvtoolnix
      monolith
      moreutils
      nmap
      neofetch
      pass
      pdftk
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
      wl-clipboard
      xclip
      xss-lock
      xsv
      youtube-dl
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
    imports = [
      ./calibre
      ./keybase
      ./kitty
      ./mpv
      ./user-dirs
    ];

    home.packages = with pkgs; [
      arandr
      feh
      discord
      slack
      gimp
      gnome3.gedit
      gnome3.nautilus
      grim
      maim
      meld
      signal
      slurp
      spotify
      tdesktop
      xorg.xkill
      # Excluding this because open PDF is broken.
      # zotero
      # Excluding this for proper QT theming.
      # transmission-qt
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
      # Nerd Fonts contains patched fonts (incl. Iosevka)
      iosevka-bin
      source-code-pro
      source-sans-pro
      noto-fonts
      noto-fonts-cjk
    ];
  };
}