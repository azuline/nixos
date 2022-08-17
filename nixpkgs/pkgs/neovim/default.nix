{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    ];
    extraConfig = ''
      luafile ${builtins.toString ../../../nvim/_init.lua}
    '';
  };
}
