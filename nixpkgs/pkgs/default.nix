{
  cliModule = ({ config, pkgs, ... }: {
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
  });

  devModule = ({ config, pkgs, ... }: {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    services.lorri.enable = true;

    imports = [
      ./python
      ./haskell
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
      ghc
      gitAndTools.delta
      gitAndTools.gh
      go_1_18
      gofumpt
      golangci-lint
      google-cloud-sdk
      gopls
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
      python39Packages.flake8
      rnix-lsp
      selene
      shellcheck
      sqlint
      stack
      stylua
      sumneko-lua-language-server
      universal-ctags
      watchman # Needed for tsserver
      yarn
    ];
  });

  envModule = ({ config, pkgs, ... }: {
    xdg.configFile."user-dirs.dirs".source = ../configFiles/user-dirs.dirs;
    xdg.configFile."direnv/direnv.toml".source = ../configFiles/direnv.toml;
    home.file.".inputrc".source = ../configFiles/inputrc;
  });

  guiModule = ({ config, pkgs, specialArgs, ... }: {
    imports = [
      ./keybase
      ./kitty
      ./mpv
      ./signal
    ] ++ (
      # Excluding this on neptune since it can't connect.
      if specialArgs.host == "splendor" then [ ./discord ] else [ ]
    );

    home.packages = with pkgs; [
      arandr
      feh
      gimp
      gnome3.gedit
      gnome3.nautilus
      grim
      maim
      meld
      slurp
      spotify
      tdesktop
      xorg.xkill
      # Excluding this because open PDF is broken.
      # zotero
      # Excluding this for proper QT theming.
      # transmission-qt
    ] ++ (
      # Excluding this on neptune since it can't connect.
      if specialArgs.host == "splendor" then [ slack ] else [ ]
    );
  });

  i3Module = ({ config, pkgs, specialArgs, ... }: {
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
      ./i3wsr
    ];

    home.file.".xsessionrc".source = ../configFiles/i3-xsessionrc;
  });

  swayModule = ({ config, pkgs, specialArgs, ... }: {
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

  themeModule = ({ config, pkgs, ... }: {
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
