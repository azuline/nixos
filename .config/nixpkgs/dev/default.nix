{ pkgs, ... }:

{
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.fish.enable = true;

  home.packages = with pkgs; [
    autossh
    jq
    rnix-lsp
  ];
}
