{ config, specialArgs, ... }:

let
  nvimDir = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/neovim";
  theme = specialArgs.sys.theme or "cool";
  colorscheme = if theme == "warm" then "gruvbox" else "palenight";
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    extraConfig = ''
      let g:theme_name = "${colorscheme}"
      source ${nvimDir}/vimrc
      luafile ${nvimDir}/init.lua
    '';
  };

  xdg.configFile = {
    "nvim/lua".source = "${nvimDir}/lua";
    "nvim/autoload".source = "${nvimDir}/autoload";
    "nvim/snippets".source = "${nvimDir}/snippets";
    "nvim/ftplugin".source = "${nvimDir}/ftplugin";
  };
}
