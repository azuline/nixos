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
      "model": "claude-sonnet-4-5",
      "provider": {
        "anthropic": {
          "models": {
            "claude-sonnet-4-5[1M]": {
              "id": "claude-sonnet-4-5-20250929",
              "name": "Claude Sonnet 4.5 [1M]",
              "headers": {
                "anthropic-beta": "context-1m-2025-08-07"
              },
              "limit": {
                "context": 1000000,
                "output": 64000
              }
            }
          }
        }
      }
    }
  '';
}
