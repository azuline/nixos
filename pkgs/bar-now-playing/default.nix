{ writeShellScriptBin, coreutils, gnused, socat, jq, bc }:

# TODO: Read the audio file and maintain a cache in ~/.local/cache.
writeShellScriptBin "bar-now-playing" ''
  export PATH="${bc}/bin:${jq}/bin:${gnused}/bin:${socat}/bin:${coreutils}/bin:/run/current-system/sw/bin:$PATH"

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

  filepath="$(get_property path)"
  track_text="$(basename "$filepath" | sed 's/\.[^.]*$//' | sed 's/^[0-9\-]*\. //')"
  album_text="$(basename "$(dirname "$filepath")")"

  time_pos="$(get_property time-pos)"
  time_total="$(echo "$(get_property time-remaining) + $time_pos" | bc)"
  time_pos="$(date -d "@$time_pos" +"%-M:%S")"
  time_total="$(date -d "@$time_total" +"%-M:%S")"

  playlist_pos="$(get_property playlist-pos | tr -d "\n" | cat - <(echo "+1") | bc)"
  playlist_total="$(get_property playlist-count)"

  printf "%s" "($time_pos/$time_total) [$playlist_pos/$playlist_total] $track_text"
  if [ "$(hostname)" = "splendor" ]; then
    printf "%s" " from $album_text"
  fi
  echo
''
