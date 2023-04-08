{ system, nixpkgs, srcs, pins }:

import nixpkgs {
  inherit system;
  overlays = [
    (self: super:
      let
        pkgs = super // pins;
        i3-lock = import ./i3-lock { inherit pkgs; };
      in
      pins // {
        bar-gpu = import ./bar-gpu { inherit pkgs; };
        bar-loadavg = import ./bar-loadavg { inherit pkgs; };
        bar-vpn = import ./bar-vpn { inherit pkgs; };
        decrypt-zen = import ./decrypt-zen { inherit pkgs; };
        discord = import ./discord { inherit pkgs srcs; };
        flexget = import ./flexget { inherit pkgs; };
        i3-atelier = import ./i3-atelier { inherit pkgs; };
        i3-change-audio = import ./i3-change-audio { inherit pkgs; };
        i3-clear-clipboard = import ./i3-clear-clipboard { inherit pkgs; };
        i3-lock-nixos = i3-lock.nixos;
        i3-lock-debian = i3-lock.debian;
        i3-pass = import ./i3-pass { inherit pkgs; };
        i3-screenshot = import ./i3-screenshot { inherit pkgs; };
        i3-yy = import ./i3-yy { inherit pkgs; };
        neovim = import ./neovim { inherit pkgs; };
        python = import ./python { inherit pkgs; };
        signal = import ./signal { inherit pkgs; };
        sway-clear-clipboard = import ./sway-clear-clipboard { inherit pkgs; };
        sway-pass = import ./sway-pass { inherit pkgs; };
        sway-yy = import ./sway-yy { inherit pkgs; };
        win-switch = import ./win-switch { inherit pkgs; };
      })
  ];
}
