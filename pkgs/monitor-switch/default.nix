{ writeShellScriptBin }:

writeShellScriptBin "monitor-switch" ''
  function monitorOn() {
    # Monitor on
    xrandr --output DP-2 --auto
    xrandr --output DP-2 --right-of eDP-1
    xrandr --output DP-2 --primary
    systemctl --user restart polybar
    xwallpaper --output DP-2 --focus ~/backgrounds/right.png --output eDP-1 --focus ~/backgrounds/left.png
    home-manager switch --flake /etc/nixos/#haiqin-monitor
  }

  function monitorOff() {
    # Monitor off
    xrandr --output DP-2 --off
    systemctl --user restart polybar
    home-manager switch --flake /etc/nixos/#haiqin
  }

  if xrandr --listactivemonitors | grep "DP-2"; then
    monitorOn
  else
    monitorOff
  fi
''
