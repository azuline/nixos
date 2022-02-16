{
  cliModule = ({ pkgs, ... }: {
    programs.fish.enable = true;
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.extraConfig = ''
      pinentry-program /usr/bin/pinentry-gtk-2
    '';

    imports = [
      ./git
      ./tmux
    ];

    home.packages = with pkgs; [
      autossh
      bat
      brightnessctl
      curl
      dnsutils
      dolt
      exa
      fd
      fzf
      graphviz
      imagemagick
      jq
      mediainfo
      mkvtoolnix
      neofetch
      # Broken with some plugins due to missing libc++.
      neovim
      nnn
      pass
      pdftk
      procps-ng
      python39Packages.pipx
      python39Packages.shodan
      ripgrep
      rsync
      rsync
      speedtest-cli
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
      ccls
      clang-tools
      docker-compose
      gdb
      gitAndTools.delta
      gitAndTools.gh
      google-cloud-sdk
      google-cloud-sdk
      kubectl
      minikube
      nodePackages.lerna
      nodejs
      php80
      php80Packages.composer
      postgresql_13
      rnix-lsp
      shellcheck
      sqlint
      stack
      watchman # Needed for coc-tsserver
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
      # Excluding this on neptune since it can't connect.
      slack
      spotify
      tdesktop
      ungoogled-chromium
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

  i3Module = ({ config, pkgs, ... }:
    let
      bar-loadavg = pkgs.writeScriptBin "bar-loadavg" (builtins.readFile ../scripts/bar-loadavg.sh);
      bar-gpu = pkgs.writeScriptBin "bar-gpu" (builtins.readFile ../scripts/bar-gpu.sh);
      i3-clear-clipboard =
        pkgs.writeScriptBin "i3-clear-clipboard" (builtins.readFile ../scripts/i3-clear-clipboard.sh);
      i3-lock = pkgs.writeScriptBin "i3-lock" (builtins.readFile ../scripts/i3-lock.sh);
      i3-pass = pkgs.writeScriptBin "i3-pass" (builtins.readFile ../scripts/i3-pass.sh);
      i3-yy = pkgs.writeScriptBin "i3-yy" (builtins.readFile ../scripts/i3-yy.sh);
    in
    {
      imports = [
        ./dunst
        ./i3
        ./picom
        ./polybar
        ./rofi
      ];

      home.file.".xsessionrc".source = ../configFiles/profile;

      home.packages = [
        bar-loadavg
        bar-gpu
        i3-clear-clipboard
        i3-lock
        i3-pass
        i3-yy
      ];
    });

  swayModule = ({ config, pkgs, ... }:
    let
      sway-clear-clipboard =
        pkgs.writeScriptBin "sway-clear-clipboard" (builtins.readFile ../scripts/sway-clear-clipboard.sh);
      sway-pass = pkgs.writeScriptBin "sway-pass" (builtins.readFile ../scripts/sway-pass.sh);
      sway-yy = pkgs.writeScriptBin "sway-yy" (builtins.readFile ../scripts/sway-yy.sh);
    in
    {
      imports = [
        ./dunst
        ./rofi
        ./sway
        ./swaylock
        ./waybar
      ];

      home.file.".profile".source = ../configFiles/profile;

      home.packages = with pkgs; [
        swayidle
        # Change the name of a workspace based on its contents.
        swaywsr
        sway-clear-clipboard
        sway-pass
        sway-yy
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
