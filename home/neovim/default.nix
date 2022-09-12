{ pkgs, config, specialArgs, ... }:

let
  # These plugins are erroring with nvim-treesitter.
  grammars = builtins.filter
    ({ name, ... }: builtins.match "tree-sitter-(lua|sql|vim|kotlin|javascript)-.*" name == null)
    pkgs.tree-sitter.allGrammars;
in

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (_: grammars))
    ];
    extraConfig = ''
      ${builtins.readFile ./vimrc}
      luafile ${builtins.toString ./init.lua}
    '';
  };

  xdg.configFile = {
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/neovim/lua";
    "nvim/autoload".source = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/neovim/autoload";
    "nvim/snippets".source = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/neovim/snippets";
  };
}
