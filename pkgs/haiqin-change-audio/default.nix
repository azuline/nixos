{ writeShellScriptBin }:

writeShellScriptBin "i3-change-audio" ''
  set -euo pipefail

  wired_headphones_sink="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
  wireless_earbuds_sink="bluez_output.80_99_E7_1D_0C_B2.1"
  bt_headphones_sink="bluez_output.CC_98_8B_E3_18_BC.1"

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
    if sink_exists "$wireless_earbuds_sink"; then
      new_sink="$wireless_earbuds_sink"
    elif sink_exists "$bt_headphones_sink"; then
      new_sink="$bt_headphones_sink"
    fi
  elif [[ "$default_sink" == "$wireless_earbuds_sink" ]]; then
    if sink_exists "$bt_headphones_sink"; then
      new_sink="$bt_headphones_sink"
    elif sink_exists "$wired_headphones_sink"; then
      new_sink="$wired_headphones_sink"
    fi
  elif [[ "$default_sink" == "$bt_headphones_sink" ]]; then
    if sink_exists "$wired_headphones_sink"; then
      new_sink="$wired_headphones_sink"
    elif sink_exists "$wireless_earbuds_sink"; then
      new_sink="$wireless_earbuds_sink"
    fi
  else
    new_sink="$wired_headphones_sink"
  fi

  if [[ -z "$new_sink" ]]; then
    notify-send "No other audio sinks connected."
    exit 0
  fi

  # Notify the user.
  if [[ "$new_sink" == "$wired_headphones_sink" ]]; then
    notify-send "Switched audio to Builtin Output."
  elif [[ "$new_sink" == "$wireless_earbuds_sink" ]]; then
    notify-send "Switched audio to True Wireless Earbuds."
  elif [[ "$new_sink" == "$bt_headphones_sink" ]]; then
    notify-send "Switched audio to Bluetooth Headphones."
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
