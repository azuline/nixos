{
  writeShellScriptBin,
  monitor ? "HDMI-1",
}:

writeShellScriptBin "monitor-switch" ''
  set -euo pipefail

  function monitorOn() {
    # Monitor on
    xrandr --output ${monitor} --auto --primary --above eDP-1
    sleep 1
    /home/blissful/backgrounds/apply.sh
    /home/blissful/backgrounds/gen_lock.sh
    home-manager switch --flake /etc/nixos/#haiqin-monitor
    systemctl --user restart polybar
    i3-msg reload
    sed -i 's/"layout.css.devPixelsPerPx", "1"/"layout.css.devPixelsPerPx", "0.75"/' /home/blissful/.mozilla/firefox/ags1n97b.default-1691722184231/user.js
    if pkill firefox; then
      firefox &
      disown
    fi
  }

  function monitorOff() {
    # Monitor off
    xrandr --output eDP-1 --auto --primary
    xrandr --output ${monitor} --off
    sleep 1
    /home/blissful/backgrounds/apply.sh
    /home/blissful/backgrounds/gen_lock.sh
    home-manager switch --flake /etc/nixos/#haiqin
    systemctl --user restart polybar
    i3-msg reload
    sed -i 's/"layout.css.devPixelsPerPx", "0.75"/"layout.css.devPixelsPerPx", "1"/' /home/blissful/.mozilla/firefox/ags1n97b.default-1691722184231/user.js
    if pkill firefox; then
      firefox &
      disown
    fi
  }

  # Kill other instances.
  # kill $(pgrep -f "monitor-switch" | grep -vw $$) 2>/dev/null

  cond="$(xrandr --query | { grep "${monitor} connected" || true; })"
  if [[ -n "$cond" ]]; then
    monitorOn
  else
    monitorOff
  fi
''

# BELOW IS FOR SIZED UP SINGLE MONITORS

# writeShellScriptBin "monitor-switch" ''
#   set -euo pipefail

#   function monitorOn() {
#     # Monitor on
#     xrandr --output ${monitor} --auto --primary
#     xrandr --output eDP-1 --off
#     sleep 1
#     xwallpaper --output ${monitor} --focus ~/backgrounds/monitor.png
#     home-manager switch --flake /etc/nixos/#haiqin-monitor
#     systemctl --user restart polybar
#     sed -i 's/"layout.css.devPixelsPerPx", "1"/"layout.css.devPixelsPerPx", "0.75"/' /home/blissful/.mozilla/firefox/ags1n97b.default-1691722184231/user.js
#     if pkill firefox; then
#       firefox &
#       disown
#     fi
#   }

#   function monitorOff() {
#     # Monitor off
#     xrandr --output eDP-1 --auto --primary
#     xrandr --output ${monitor} --off
#     sleep 1
#     xwallpaper --output eDP-1 --focus ~/backgrounds/bg.png
#     home-manager switch --flake /etc/nixos/#haiqin
#     systemctl --user restart polybar
#     sed -i 's/"layout.css.devPixelsPerPx", "0.75"/"layout.css.devPixelsPerPx", "1"/' /home/blissful/.mozilla/firefox/ags1n97b.default-1691722184231/user.js
#     if pkill firefox; then
#       firefox &
#       disown
#     fi
#   }

#   # Kill other instances.
#   # kill $(pgrep -f "monitor-switch" | grep -vw $$) 2>/dev/null

#   cond="$(xrandr --query | { grep "${monitor} connected" || true; })"
#   if [[ -n "$cond" ]]; then
#     monitorOn
#   else
#     monitorOff
#   fi
# ''
