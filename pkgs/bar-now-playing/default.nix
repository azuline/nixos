{ writeShellScriptBin, coreutils, gnused, socat, jq, bc }:

writeShellScriptBin "bar-now-playing" ''
  export PATH="${bc}/bin:${jq}/bin:${gnused}/bin:${socat}/bin:${coreutils}/bin:$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"

  set -euo pipefail

  # Redirect stderr to /dev/null
  exec 2>/dev/null

  # Print N/A if there is an error (which occurs if mpv is not running).
  trap 'exit_handler' EXIT
  exit_handler() {
    if [ $? -ne 0 ]; then
      echo "N/A"
      exit 0
    fi
  }

  get_property() {
    echo "{ \"command\": [\"get_property_string\", \"$1\"] }" | socat - "$XDG_RUNTIME_DIR/mpv-playmusic" | jq -r ".data"
  }

  arrayfmt() {
    jq -r '[.[]] | if length == 0 then ""
           elif length == 1 then .[0] 
           elif length == 2 then join(" & ") 
           else (.[0:-1] | join(", ")) + " & " + .[-1] 
           end'
  }

  filepath="$(get_property path)"
  data="$(rose tracks print "$filepath")"

  tracktitle="$(echo "$data" | jq -r .tracktitle)"
  albumtitle="$(echo "$data" | jq -r .albumtitle)"
  year="$(echo "$data" | jq -r .year)"

  artists="$(echo "$data" | jq '.trackartists.main | map(select(.alias == false) | .name)' | arrayfmt)"
  guest_artists="$(echo "$data" | jq '.trackartists.guest | map(select(.alias == false) | .name)' | arrayfmt)"
  if [ -n "$guest_artists" ]; then
    artists="$artists (feat. $guest_artists)"
  fi

  time_pos="$(get_property time-pos)"
  time_total="$(echo "$(get_property time-remaining) + $time_pos" | bc)"
  time_pos="$(date -d "@$time_pos" +"%-M:%S")"
  time_total="$(date -d "@$time_total" +"%-M:%S")"

  playlist_pos="$(get_property playlist-pos | tr -d "\n" | cat - <(echo "+1") | bc)"
  playlist_total="$(get_property playlist-count)"

  printf "%s" "($time_pos/$time_total) [$playlist_pos/$playlist_total] $tracktitle by $artists"
  if [ "$(hostname)" = "splendor" ]; then
    printf "%s" " from $albumtitle"
    if [ -n "$year" ]; then
      printf "%s" " ($year)"
    fi
  fi
  echo
''
