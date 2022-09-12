{ pkgs }:

pkgs.writeShellScriptBin "i3-change-audio" ''
  default_sink="$(pactl get-default-sink)"

  # Compute the new sink. We default to headphones, but toggle to bluetooth
  # if already headphones.
  new_sink="alsa_output.pci-0000_0d_00.4.analog-stereo"
  if [[ "$default_sink" == "alsa_output.pci-0000_0d_00.4.analog-stereo" ]]; then
    new_sink="bluez_sink.78_2B_64_5C_F4_AA.a2dp_sink"
  fi

  # Update the default sink.
  pactl set-default-sink "$new_sink"

  # Update existing applications to output to the new sink.
  pactl list sink-inputs | \
    grep 'Sink Input #' | \
    cut -d'#' -f2 | \
    xargs -I{} sh -c "pactl move-sink-input {} $new_sink"
''
