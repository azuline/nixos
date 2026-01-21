{ writeShellScriptBin }:

writeShellScriptBin "win-switch" ''
  function windowsOn() {
    xrandr --output DP-4 --off
    systemctl restart --user polybar
    synergy &
    disown
  }

  function windowsOff() {
    # XRandr
    xrandr --output DP-4 --auto
    xrandr --output DP-4 --right-of DP-2
    systemctl restart --user polybar
    pkill synergy
  }

  if ps ax | grep synergy | grep -v grep; then
    windowsOff
  else
    windowsOn
  fi
''
