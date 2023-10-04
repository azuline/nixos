{ pkgs, config, specialArgs, ... }:

let
  nvimDir = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/neovim";
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
    extraConfig = ''
      ${builtins.readFile ./vimrc}
      luafile ${nvimDir}/init.lua
    '';
  };

  xdg.configFile = {
    "nvim/lua".source = "${nvimDir}/lua";
    "nvim/autoload".source = "${nvimDir}/autoload";
    "nvim/coq-user-snippets".source = "${nvimDir}/coq-user-snippets";
  };
}
