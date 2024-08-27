{ writeShellScriptBin, monitor ? "HDMI-1" }:

writeShellScriptBin "monitor-switch" ''
  set -euo pipefail

  function monitorOn() {
    # Monitor on
    xrandr --output ${monitor} --auto --primary
    xrandr --output eDP-1 --off
    sleep 1
    xwallpaper --output ${monitor} --focus ~/backgrounds/monitor.png
    home-manager switch --flake /etc/nixos/#haiqin-monitor
    systemctl --user restart polybar
  }

  function monitorOff() {
    # Monitor off
    xrandr --output eDP-1 --auto --primary
    xrandr --output ${monitor} --off
    sleep 1
    xwallpaper --output eDP-1 --focus ~/backgrounds/bg.png
    home-manager switch --flake /etc/nixos/#haiqin
    systemctl --user restart polybar
  }

  cond="$(xrandr --query | { grep "${monitor} connected" || true; })"
  if [[ -n "$cond" ]]; then
    monitorOn
  else
    monitorOff
  fi
''
