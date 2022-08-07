{
  cliModule = ({ pkgs, ... }: {
    programs.fish.enable = true;
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.extraConfig = ''
      pinentry-program /usr/bin/pinentry-gtk-2
      default-cache-ttl 14400
      max-cache-ttl 14400
    '';

    imports = [
      ./git
      ./tmux
    ];

    home.packages = with pkgs; [
      autossh
      xsv
      bat
      brightnessctl
      ffmpeg
      cmus
      curl
      dnsutils
      exa
      fd
      monolith
      fzf
      graphviz
      imagemagick
      jq
      mediainfo
      mktorrent
      mkvtoolnix
      mypy
      neofetch
      # Broken with some plugins due to missing libc++.
      neovim
      nnn
      pass
      pdftk
      poetry
      procps
      python39Packages.pip
      python39Packages.pipx
      python39Packages.shodan
      ripgrep
      rsync
      rsync
      speedtest-cli
      termdown
      unixtools.netstat
      sqlite-interactive
      sshfs
      tldr
      trash-cli
      tree
      unrar
      weechat
      wget
      whois
      wl-clipboard
      xclip
      xss-lock
    ];
  });

  devModule = ({ pkgs, ... }: {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    services.lorri.enable = true;

    imports = [
      ./haskell
      ./flake8
    ];

    home.packages = with pkgs; [
      ack
      act
      berglas
      bfg-repo-cleaner
      black
      ccls
      clang-tools
      docker
      docker-compose
      gdb
      gitAndTools.delta
      gitAndTools.gh
      go_1_18
      jdk11
      gofumpt
      golangci-lint
      gopls
      google-cloud-sdk
      kubectl
      minikube
      nodejs
      nodePackages.eslint
      nodePackages.eslint_d
      nodePackages.pnpm
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nixpkgs-fmt
      php80
      php80Packages.composer
      postgresql_13
      python39Full
      rnix-lsp
      shellcheck
      sqlint
      stack
      cabal-install
      haskellPackages.implicit-hie
      haskell-language-server
      ghc
      watchman # Needed for tsserver
      yarn
    ];
  });

  envModule = ({ pkgs, ... }: {
    xdg.configFile."user-dirs.dirs".source = ../configFiles/user-dirs.dirs;
    xdg.configFile."direnv/direnv.toml".source = ../configFiles/direnv.toml;
    home.file.".inputrc".source = ../configFiles/inputrc;
  });

  guiModule = ({ config, pkgs, ... }: {
    imports = [
      ./discord
      # Excluding this on neptune so XWayland can open links.
      ./firefox
      ./keybase
      ./kitty
      ./alacritty
      ./mpv
      ./signal
    ];

    home.packages = with pkgs; [
      arandr
      feh
      gimp
      gnome3.gedit
      gnome3.nautilus
      maim
      meld
      # Excluding this on neptune since it can't connect.
      slack
      spotify
      tdesktop
      # Takes forever to compile...
      # ungoogled-chromium
      # Can't dl...
      xorg.xkill
      grim
      slurp
      # Excluding this because open PDF is broken.
      # zotero
      # Excluding this for proper QT theming.
      # transmission-qt
    ];
  });

  i3Module = ({ config, pkgs, ... }: {
    imports = [
      ./bar-gpu
      ./bar-loadavg
      ./dunst
      ./i3
      ./i3-change-audio
      ./i3-clear-clipboard
      ./i3-lock
      ./i3-pass
      ./i3-screenshot
      ./i3-yy
      ./picom
      ./polybar
      ./rofi
    ];

    # I have no idea where to get these.
    # home.packages = with pkgs; [
    #   pacmd
    #   pactl
    # ];

    home.file.".xsessionrc".source = ../configFiles/i3-xsessionrc;
  });

  swayModule = ({ config, pkgs, ... }: {
    imports = [
      ./dunst
      ./rofi
      ./sway
      ./sway-clear-clipboard
      ./sway-pass
      ./sway-yy
      ./swaylock
      ./waybar
    ];

    home.file.".profile".source = ../configFiles/sway-profile;

    home.packages = with pkgs; [
      swayidle
      swaywsr
    ];
  });

  themeModule = ({ pkgs, ... }: {
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
  });
}
