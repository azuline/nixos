{ pkgs, config, specialArgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
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
