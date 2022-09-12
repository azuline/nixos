{ pkgs }:

pkgs.neovim.override {
  vimAlias = true;
  withPython3 = true;
  configure = {
    customRC = builtins.readFile ./vimrc;
  };
}
