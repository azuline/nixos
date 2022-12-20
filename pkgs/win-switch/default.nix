{ pkgs }:

pkgs.writeShellScriptBin "win-switch" ''
  function windowsOn() {
    # XRandr
    xrandr --output HDMI-0 --off

    # Polybar
    pkill -f 'polybar right'

    # Background
    feh --bg-fill ~/backgrounds/left.png

    synergy &
    disown
  }

  function windowsOff() {
    # XRandr
    xrandr --output HDMI-0 --auto
    xrandr --output HDMI-0 --right-of DP-0

    # Polybar
    systemctl restart --user polybar

    # Background
    feh --bg-fill ~/backgrounds/{right,left}.png

    pkill synergy
  }

  if ps ax | grep synergy | grep -v grep; then
    windowsOff
  else
    windowsOn
  fi
''
