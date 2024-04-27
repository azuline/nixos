{ writeShellScriptBin, coreutils, gnused, socat, jq, bc }:

writeShellScriptBin "bar-now-playing" ''
  export PATH="${bc}/bin:${jq}/bin:${gnused}/bin:${socat}/bin:${coreutils}/bin:$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"

  set -euo pipefail

  # Redirect stderr to /dev/null
  exec 2>/dev/null

  exit_handler() {
    if [ $? -ne 0 ]; then
      echo "N/A"
      exit 0
    fi
  }
  # Print N/A if there is an error (which occurs if mpv is not running).
  trap 'exit_handler' EXIT

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

  trim() {
    local data
    read -r data

    if (( "''${#data}" > "$1" )); then
      echo "''${data:0:$1}..."
    else
      echo "$data"
    fi
  }

  now_playing() {
    local data
    read -r data

    tracktitle="$(echo "$data" | jq -r .tracktitle)"
    albumtitle="$(echo "$data" | jq -r .releasetitle)"
    year="$(echo "$data" | jq -r .releasedate | sed 's/^\(....\).*/\1/')"

    artists="$(echo "$data" | jq '.trackartists.main | map(select(.alias == false) | .name)' | arrayfmt)"
    guest_artists="$(echo "$data" | jq '.trackartists.guest | map(select(.alias == false) | .name)' | arrayfmt)"
    if [ -n "$guest_artists" ]; then
      artists="$artists (feat. $guest_artists)"
    fi

    time_pos_sec="$(get_property time-pos)"
    time_pos="$(date -u -d "@$time_pos_sec" +"%H:%M:%S" | sed 's/^00://' | sed 's/^0//')"
    time_total_sec="$(echo "$(get_property time-remaining) + $time_pos_sec" | bc)"
    time_total="$(date -u -d "@$time_total_sec" +"%H:%M:%S" | sed 's/^00://' | sed 's/^0//')"

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
  }

  max_len=80
  if [ "$(hostname)" = "splendor" ]; then
    max_len=140
  fi

  get_property path | xargs -d'\n' rose tracks print | now_playing | trim "$max_len"
''
