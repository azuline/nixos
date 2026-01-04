{ pkgs, ... }:
{
  home.packages = with pkgs; [
    opencode
  ];

  xdg.configFile."opencode/config.json".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "theme": "gruvbox",
      "autoupdate": false,
      "model": "claude-sonnet-4-5"
    }
  '';
}
