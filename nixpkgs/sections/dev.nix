{ pkgs, ... }:

{
  # programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  imports = [
    ../pkgs/haskell
  ];

  home.packages = with pkgs; [
    act
    bfg-repo-cleaner
    docker-compose
    gitAndTools.gh
    rnix-lsp
  ];
}
