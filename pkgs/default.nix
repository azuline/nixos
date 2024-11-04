{ system, nixpkgs, srcs, pins }:

import nixpkgs {
  inherit system;
  overlays = [
    (final: prev: {
      aerc-in-kitty = prev.callPackage ./aerc-in-kitty { };
      backup-scripts = prev.callPackage ./backup-scripts { };
      bar-gpu = prev.callPackage ./bar-gpu { };
      bar-now-playing = prev.callPackage ./bar-now-playing { };
      bar-loadavg = prev.callPackage ./bar-loadavg { };
      bar-vpn = prev.callPackage ./bar-vpn { };
      decrypt-frieren = prev.callPackage ./decrypt-frieren { };
      discord = prev.callPackage ./discord { inherit srcs; original = prev.discord; };
      exif-mtime-sync = prev.callPackage ./exif-mtime-sync { };
      edit-toc = prev.callPackage ./edit-toc { };
      i3-atelier-identifier = prev.callPackage ./i3-atelier-identifier { };
      i3-atelier-opener = prev.callPackage ./i3-atelier-opener { };
      i3-clear-clipboard = prev.callPackage ./i3-clear-clipboard { };
      i3-lock = prev.callPackage ./i3-lock { };
      i3-pass = prev.callPackage ./i3-pass { };
      i3-screenshot = prev.callPackage ./i3-screenshot { };
      i3-yy = prev.callPackage ./i3-yy { };
      file-uploader = prev.callPackage ./file-uploader { };
      neovim = prev.callPackage ./neovim { };
      nsxiv = prev.callPackage ./nsxiv { inherit srcs; original = prev.nsxiv; };
      python = prev.callPackage ./python { };
      signal = prev.callPackage ./signal { };
      tremotesf = prev.callPackage ./tremotesf { original = prev.tremotesf; };
      transmission_4 = prev.callPackage ./transmission { original = prev.transmission_4; };
      win-switch = prev.callPackage ./win-switch { };
      zathura = prev.callPackage ./zathura { inherit srcs; original = prev.zathura; };
      splendor-change-audio = prev.callPackage ./splendor-change-audio { };
      haiqin-change-audio = prev.callPackage ./haiqin-change-audio { };
      monitor-switch = prev.callPackage ./monitor-switch { };
    })
    (final: prev: prev // pins)
  ];
}
