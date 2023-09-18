{ system, nixpkgs, srcs, pins, devenv }:

import nixpkgs {
  inherit system;
  overlays = [
    (self: super:
      pins // {
        backup-scripts = self.callPackage ./backup-scripts { };
        bar-gpu = import ./bar-gpu { pkgs = super; };
        bar-loadavg = import ./bar-loadavg { pkgs = super; };
        bar-vpn = import ./bar-vpn { pkgs = super; };
        decrypt-zen = import ./decrypt-zen { pkgs = super; };
        devenv = devenv.packages.${system}.devenv;
        discord = import ./discord { pkgs = super; inherit srcs; };
        flexget = import ./flexget { pkgs = super; };
        i3-atelier = import ./i3-atelier { pkgs = super; };
        i3-change-audio = import ./i3-change-audio { pkgs = super; };
        i3-clear-clipboard = import ./i3-clear-clipboard { pkgs = super; };
        i3-lock = import ./i3-lock { pkgs = super; };
        i3-pass = import ./i3-pass { pkgs = super; };
        i3-screenshot = import ./i3-screenshot { pkgs = super; };
        i3-yy = import ./i3-yy { pkgs = super; };
        neovim = import ./neovim { pkgs = super; };
        python = import ./python { pkgs = super; };
        signal = import ./signal { pkgs = super; };
        tremotesf = import ./tremotesf { pkgs = super; };
        win-switch = import ./win-switch { pkgs = super; };
      })
  ];
}
