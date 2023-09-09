{ pkgs }:

pkgs.writeShellScriptBin "i3-change-audio" ''
  set -euo pipefail

  wired_headphones_sink="alsa_output.pci-0000_0d_00.4.iec958-stereo"
  desktop_speaker_sink="bluez_sink.0A_11_75_33_AD_49.a2dp_sink"
  bt_headphones_sink="bluez_sink.CC_98_8B_E3_18_BC.a2dp_sink"

  default_sink="$(pactl get-default-sink)"

  function sink_exists() {
    pactl list sinks | grep "$1"
  }

  # Compute the new sink. We cycle through the configured sinks in the order of:
  # 1. Wired headphones
  # 2. Bluetooth speaker
  # 2. Bluetooth headphones
  # Kind of lazy and bash is hard, so I just expanded the rotation into conditionals.
  new_sink=
  if [[ "$default_sink" == "$wired_headphones_sink" ]]; then
    if sink_exists "$desktop_speaker_sink"; then
      new_sink="$desktop_speaker_sink"
    elif sink_exists "$bt_headphones_sink"; then
      new_sink="$bt_headphones_sink"
    fi
  elif [[ "$default_sink" == "$desktop_speaker_sink" ]]; then
    if sink_exists "$bt_headphones_sink"; then
      new_sink="$bt_headphones_sink"
    elif sink_exists "$wired_headphones_sink"; then
      new_sink="$wired_headphones_sink"
    fi
  elif [[ "$default_sink" == "$bt_headphones_sink" ]]; then
    if sink_exists "$desktop_speaker_sink"; then
      new_sink="$desktop_speaker_sink"
    fi
    # Don't transition from BT headphones to wired headphones; if we have BT
    # headphones connected, we will _always_ want that over wired headphones.
  else
    new_sink="$wired_headphones_sink"
  fi

  if [[ -z "$new_sink" ]]; then
    notify-send "No other audio sinks connected."
    exit 0
  fi

  # Notify the user.
  if [[ "$new_sink" == "$wired_headphones_sink" ]]; then
    notify-send "Switched audio to Wired Output."
  elif [[ "$new_sink" == "$desktop_speaker_sink" ]]; then
    notify-send "Switched audio to LSX II Speakers."
  elif [[ "$new_sink" == "$bt_headphones_sink" ]]; then
    notify-send "Switched audio to Sony WH-1000XM3."
  fi

  # Update pulseaudio's default sink.
  echo "new_sink=$new_sink"
  pactl set-default-sink "$new_sink"

  # Update existing applications to output to the new sink.
  # Will fail if there are no existing applications.
  pactl list sink-inputs | \
    grep 'Sink Input #' | \
    cut -d'#' -f2 | \
    xargs -I{} sh -c "pactl move-sink-input {} $new_sink"
''
