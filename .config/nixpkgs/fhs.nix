with import <nixpkgs> { };

buildFHSUserEnv {
  name = "enter-fhs";
  targetPkgs = pkgs: with pkgs; [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    file
    fontconfig
    freetype
    gdb
    git
    glib
    glibc
    libnotify
    libxml2
    libxslt
    netcat
    nspr
    nss
    strace
    udev
    watch
    wget
    which
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.xcbutilkeysyms
    zlib
    zsh
  ];
  runScript = "$SHELL";
}
