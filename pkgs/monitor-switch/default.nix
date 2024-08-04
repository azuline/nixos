{ writeShellScriptBin }:

writeShellScriptBin "monitor-switch" ''
  set -euo pipefail

  function monitorOn() {
    # Monitor on
    xrandr --output HDMI-1 --auto
    xrandr --output HDMI-1 --right-of eDP-1
    xrandr --output HDMI-1 --primary
    sleep 1
    xwallpaper --output HDMI-1 --focus ~/backgrounds/right.png --output eDP-1 --focus ~/backgrounds/left.png
    home-manager switch --flake /etc/nixos/#haiqin-monitor
    systemctl --user restart polybar
  }

  function monitorOff() {
    # Monitor off
    xrandr --output HDMI-1 --off
    sleep 1
    home-manager switch --flake /etc/nixos/#haiqin
    systemctl --user restart polybar
  }

  cond="$(xrandr --query | { grep "HDMI-1 connected" || true; })"
  if [[ -n "$cond" ]]; then
    monitorOn
  else
    monitorOff
  fi
''
