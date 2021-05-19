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
    gitAndTools.delta
    google-cloud-sdk
    kubectl
    nodejs
    postgresql_13
    rnix-lsp
    shellcheck
    sqlint
    watchman # Needed for coc-tsserver
    yarn
  ];
}
