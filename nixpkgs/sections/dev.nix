{ pkgs, ... }:

{
  # programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  imports = [
    ../pkgs/haskell
  ];

  home.packages = with pkgs; [
    ack
    act
    bfg-repo-cleaner
    docker-compose
    gitAndTools.gh
    rnix-lsp
    sqlint
    yarn
  ];
}
