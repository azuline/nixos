{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cabal-install
    ghc
  ];

  home.file.".ghc/ghci.conf".source = ./ghci.conf;
}
