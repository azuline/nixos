{ writeShellScriptBin }:

writeShellScriptBin "win-switch" ''
  function windowsOn() {
    # XRandr
    xrandr --output HDMI-0 --off

    # Polybar
    pkill -f 'polybar splendor-right'

    synergy &
    disown
  }

  function windowsOff() {
    # XRandr
    xrandr --output HDMI-0 --auto
    xrandr --output HDMI-0 --right-of DP-0
    xrandr --output DP-0 --primary

    # Polybar
    systemctl restart --user polybar

    pkill synergy
  }

  if ps ax | grep synergy | grep -v grep; then
    windowsOff
  else
    windowsOn
  fi
''
