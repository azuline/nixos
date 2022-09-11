{ system, nixpkgs, srcs }:

import nixpkgs {
  inherit system;
  overlays = [
    (self: super:
      let pkgs = super; in {
        bar-gpu = import ./bar-gpu { inherit pkgs; };
        bar-loadavg = import ./bar-loadavg { inherit pkgs; };
        bar-vpn = import ./bar-vpn { inherit pkgs; };
        bashInteractive = import ./bashInteractive { inherit pkgs; };
        discord = import ./discord { inherit pkgs srcs; };
        i3-change-audio = import ./i3-change-audio { inherit pkgs; };
        i3-clear-clipboard = import ./i3-clear-clipboard { inherit pkgs; };
        i3-lock = import ./i3-lock { inherit pkgs; };
        i3-pass = import ./i3-pass { inherit pkgs; };
        i3-screenshot = import ./i3-screenshot { inherit pkgs; };
        i3-yy = import ./i3-yy { inherit pkgs; };
        neovim = import ./neovim { inherit pkgs; };
        python = import ./python { inherit pkgs; };
        signal = import ./signal { inherit pkgs; };
        sway-clear-clipboard = import ./sway-clear-clipboard { inherit pkgs; };
        sway-pass = import ./sway-pass { inherit pkgs; };
        sway-yy = import ./sway-yy { inherit pkgs; };
        vimPlugins = pkgs.vimPlugins // {
          nvim-treesitter = import ./vimPlugins/nvim-treesitter { inherit pkgs srcs; };
        };
      })
  ];
}
