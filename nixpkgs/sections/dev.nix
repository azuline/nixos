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
    gdb
    act
    bfg-repo-cleaner
    ccls
    clang-tools
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
    php80
    php80Packages.composer
    shellcheck
    sqlint
    watchman # Needed for coc-tsserver
    yarn
  ];
}
