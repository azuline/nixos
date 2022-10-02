{ pkgs, config, specialArgs, ... }:

let
  # These plugins are erroring with nvim-treesitter.
  grammars = builtins.filter
    ({ name, ... }: builtins.match "tree-sitter-(lua|sql|vim|kotlin|javascript)-.*" name == null)
    pkgs.tree-sitter.allGrammars;
  nvimDir = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/neovim";
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
      luafile ${nvimDir}/init.lua
    '';
  };

  xdg.configFile = {
    "nvim/lua".source = "${nvimDir}/lua";
    "nvim/autoload".source = "${nvimDir}/autoload";
    "nvim/snippets".source = "${nvimDir}/snippets";
  };
}
