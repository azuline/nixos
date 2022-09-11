{ pkgs, srcs }:

pkgs.vimPlugins.nvim-treesitter.overrideAttrs (_: {
  src = srcs.nvim-treesitter;
})
