{
  cliBundle = { config, pkgs, ... }: {
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
      brightnessctl
      cmus
      curl
      dnsutils
      exa
      fd
      ffmpeg
      fzf
      graphviz
      imagemagick
      jq
      mediainfo
      mktorrent
      mkvtoolnix
      monolith
      mypy
      neofetch
      pass
      pdftk
      poetry
      procps
      ripgrep
      rsync
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
    ];
  };

  devBundle = { config, pkgs, ... }: {
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

  guiBundle = { config, pkgs, ... }: {
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

  i3Bundle = { config, pkgs, ... }: {
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
      i3-change-audio
      i3-clear-clipboard
      i3-lock
      i3-pass
      i3-screenshot
      i3-yy
    ];
  };

  swayBundle = { config, pkgs, ... }: {
    imports = [
      ./dunst
      ./rofi
      ./sway
      ./swaylock
      ./waybar
    ];

    home.packages = with pkgs; [
      sway-clear-clipboard
      sway-pass
      sway-yy
      swayidle
      swaywsr
    ];
  };

  themeBundle = { config, pkgs, ... }: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # plata-theme
      # papirus-icon-theme

      font-awesome
      # Nerd Fonts contains patched fonts (incl. Iosevka)
      nerdfonts
      twitter-color-emoji
      noto-fonts
      source-code-pro
      source-sans-pro
      noto-fonts-cjk
    ];
  };
}
