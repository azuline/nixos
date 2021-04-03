{ pkgs, ... }:

{
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.fish.enable = true;

  programs.go.enable = true;

  home.packages = with pkgs; [
    act
    autossh
    jq
    rnix-lsp
  ];
}
