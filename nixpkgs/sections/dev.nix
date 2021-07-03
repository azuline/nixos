{ pkgs, ... }:

{
  # programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  imports = [
    ../pkgs/haskell
    ../pkgs/flake8
  ];

  home.packages = with pkgs; [
    ack
    act
    bfg-repo-cleaner
    docker-compose
    gitAndTools.gh
    gitAndTools.delta
    google-cloud-sdk
    kubectl
    minikube
    nodePackages.lerna
    nodejs
    postgresql_13
    rnix-lsp
    shellcheck
    sqlint
    watchman # Needed for coc-tsserver
    yarn
  ];
}
