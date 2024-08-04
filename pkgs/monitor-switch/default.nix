{ writeShellScriptBin, monitor ? "HDMI-1" }:

writeShellScriptBin "monitor-switch" ''
  set -euo pipefail

  function monitorOn() {
    # Monitor on
    xrandr --output ${monitor} --auto
    xrandr --output ${monitor} --right-of eDP-1
    xrandr --output ${monitor} --primary
    sleep 1
    xwallpaper --output ${monitor} --focus ~/backgrounds/right.png --output eDP-1 --focus ~/backgrounds/left.png
    home-manager switch --flake /etc/nixos/#haiqin-monitor
    systemctl --user restart polybar
  }

  function monitorOff() {
    # Monitor off
    xrandr --output ${monitor} --off
    sleep 1
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
