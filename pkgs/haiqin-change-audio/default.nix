{ writeShellScriptBin }:

writeShellScriptBin "i3-change-audio" ''
  set -euo pipefail

  declare -A sinks=(
    ["Laptop Speakers"]="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
    ["Laptop Headphones"]="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink"
    ["Google Cast"]="Mkchromecast"
    ["True Wireless Earbuds"]="bluez_output.80_99_E7_1D_0C_B2.1"
    ["Bluetooth Headphones"]="bluez_output.CC_98_8B_E3_18_BC.1"
    ["Bose Mini II SE SoundLink"]="bluez_output.78_2B_64_5C_F4_AA.1"
  )

  # Ordered list of sink names that we use to cycle through. Also, only the
  # sinks in here are active; inactive ones are not omitted.
  sink_names=(
    "Google Cast"
    "True Wireless Earbuds"
    "Bluetooth Headphones"
    "Bose Mini II SE SoundLink"
  )
  default_sink="$(pactl get-default-sink)"

  function sink_exists() {
    pactl list sinks | grep "$1"
  }

  # Find the index of the current default sink in the sink names array.
  current_index=-1
  for i in "''${!sink_names[@]}"; do
    if [[ "$default_sink" == "''${sinks[''${sink_names[i]}]}" ]]; then
      current_index="$i"
      break
    fi
  done

  new_sink=""
  new_sink_name=""
  for ((i = 1; i <= ''${#sink_names[@]}; i++)); do
    next_index=$(( (current_index + i) % ''${#sink_names[@]} ))
    next_name="''${sink_names[next_index]}"
    next_sink="''${sinks[$next_name]}"
    if sink_exists "$next_sink"; then
      new_sink="$next_sink"
      new_sink_name="$next_name"
      break
    fi
  done

  if [[ -z "$new_sink" ]]; then
    notify-send "No other audio sinks connected."
    exit 0
  fi

  # Notify the user.
  notify-send "Switched audio to $new_sink_name."

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
