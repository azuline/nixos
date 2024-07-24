{ writeShellScriptBin }:

writeShellScriptBin "monitor-switch" ''
  set -euo pipefail

  function monitorOn() {
    # Monitor on
    xrandr --output DP-2 --auto
    xrandr --output DP-2 --right-of eDP-1
    xrandr --output DP-2 --primary
    sleep 1
    xwallpaper --output DP-2 --focus ~/backgrounds/right.png --output eDP-1 --focus ~/backgrounds/left.png
    home-manager switch --flake /etc/nixos/#haiqin-monitor
    systemctl --user restart polybar
  }

  function monitorOff() {
    # Monitor off
    xrandr --output DP-2 --off
    sleep 1
    home-manager switch --flake /etc/nixos/#haiqin
    systemctl --user restart polybar
  }

  cond="$(xrandr --listmonitors | { grep DP-2 || true; })"
  if [[ -n "$cond" ]]; then
    monitorOn
  else
    monitorOff
  fi
''
