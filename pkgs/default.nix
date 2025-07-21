{ system, nixpkgs, srcs, pins }:

import nixpkgs {
  inherit system;
  overlays = [
    (final: prev: {
      aerc-in-kitty = prev.callPackage ./aerc-in-kitty { };
      backup-scripts = prev.callPackage ./backup-scripts { };
      bar-ddcutil = prev.callPackage ./bar-ddcutil { };
      bar-gpu = prev.callPackage ./bar-gpu { };
      bar-loadavg = prev.callPackage ./bar-loadavg { };
      bar-now-playing = prev.callPackage ./bar-now-playing { };
      bar-vpn = prev.callPackage ./bar-vpn { };
      decrypt-frieren = prev.callPackage ./decrypt-frieren { };
      decrypt-pdf = prev.callPackage ./decrypt-pdf { };
      discord = prev.callPackage ./discord { inherit srcs; original = prev.discord; };
      edit-toc = prev.callPackage ./edit-toc { };
      exif-mtime-sync = prev.callPackage ./exif-mtime-sync { };
      file-uploader = prev.callPackage ./file-uploader { };
      haiqin-change-audio = prev.callPackage ./haiqin-change-audio { };
      i3-clear-clipboard = prev.callPackage ./i3-clear-clipboard { };
      i3-lock = prev.callPackage ./i3-lock { };
      i3-screenshot = prev.callPackage ./i3-screenshot { };
      i3-yy = prev.callPackage ./i3-yy { };
      i3wsr = prev.callPackage ./i3wsr { inherit srcs; original = prev.i3wsr; };
      monitor-switch = prev.callPackage ./monitor-switch { };
      neovim = prev.callPackage ./neovim { };
      nsxiv = prev.callPackage ./nsxiv { inherit srcs; original = prev.nsxiv; };
      python = prev.callPackage ./python { };
      signal = prev.callPackage ./signal { };
      splendor-change-audio = prev.callPackage ./splendor-change-audio { };
      tailnet-switch = prev.callPackage ./tailnet-switch { };
      term-pass = prev.callPackage ./term-pass { };
      transmission_4 = prev.callPackage ./transmission { original = prev.transmission_4; };
      tremotesf = prev.callPackage ./tremotesf { original = prev.tremotesf; };
      win-switch = prev.callPackage ./win-switch { };
      zathura = prev.callPackage ./zathura { inherit srcs; original = prev.zathura; };
    })
    (final: prev: prev // pins)
  ];
}
