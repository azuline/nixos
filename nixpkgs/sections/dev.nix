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
    google-cloud-sdk
    kubectl
    nodejs
    postgresql
    rnix-lsp
    shellcheck
    sqlint
    yarn
  ];
}
