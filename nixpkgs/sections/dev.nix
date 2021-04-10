{ pkgs, ... }:

{
  # programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  imports = [
    ../pkgs/haskell
  ];

  home.packages = with pkgs; [
    act
    docker-compose
    rnix-lsp
  ];
}
