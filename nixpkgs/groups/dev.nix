{ pkgs, ... }:

{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  services.lorri.enable = true;

  imports = [
    ../pkgs/haskell
    ../pkgs/flake8
  ];

  home.packages = with pkgs; [
    ack
    act
    berglas
    bfg-repo-cleaner
    ccls
    clang-tools
    docker-compose
    gdb
    gitAndTools.delta
    gitAndTools.gh
    google-cloud-sdk
    google-cloud-sdk
    kubectl
    minikube
    nodePackages.lerna
    nodejs
    php80
    php80Packages.composer
    postgresql_13
    rnix-lsp
    shellcheck
    sqlint
    stack
    watchman # Needed for coc-tsserver
    yarn
  ];
}
