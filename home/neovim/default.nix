{
  pkgs,
  config,
  specialArgs,
  ...
}:

let
  nvimDir = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/neovim";
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    extraConfig = ''
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
