{ system, nixpkgs, srcs, pins, devenv }:

import nixpkgs {
  inherit system;
  overlays = [
    (final: prev:
      pins // {
        backup-scripts = prev.callPackage ./backup-scripts { };
        exif-mtime-sync = prev.callPackage ./exif-mtime-sync { };
        bar-gpu = prev.callPackage ./bar-gpu { };
        bar-loadavg = prev.callPackage ./bar-loadavg { };
        bar-vpn = prev.callPackage ./bar-vpn { };
        decrypt-zen = prev.callPackage ./decrypt-zen { };
        devenv = devenv.packages.${system}.devenv;
        discord = prev.callPackage ./discord {
          inherit srcs;
          original = prev.discord;
        };
        flexget = prev.callPackage ./flexget { };
        i3-atelier = prev.callPackage ./i3-atelier { };
        i3-change-audio = prev.callPackage ./i3-change-audio { };
        i3-clear-clipboard = prev.callPackage ./i3-clear-clipboard { };
        i3-lock = prev.callPackage ./i3-lock { };
        i3-pass = prev.callPackage ./i3-pass { };
        i3-screenshot = prev.callPackage ./i3-screenshot { };
        i3-yy = prev.callPackage ./i3-yy { };
        neovim = prev.callPackage ./neovim { };
        python = prev.callPackage ./python { };
        signal = prev.callPackage ./signal { };
        tremotesf = prev.callPackage ./tremotesf { original = prev.tremotesf; };
        win-switch = prev.callPackage ./win-switch { };
      })
  ];
}
