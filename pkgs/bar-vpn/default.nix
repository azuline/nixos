{ writeShellScriptBin, jq, coreutils, wireguard-tools }:

writeShellScriptBin "bar-vpn" ''
  # To lookup tailscale.
  export PATH="/run/current-system/sw/bin:$PATH"

  # https://stackoverflow.com/a/17841619
  function join_by {
    local d=''${1-} f=''${2-}
    if shift 2; then
      printf %s "$f" "''${@/#/$d}"
    fi
  }

  # If we're connected to tailscale, add the tailnet name to the VPN array.
  vpns=()
  if [[ "$(tailscale status)" != "Tailscale is stopped." ]]; then
    tailnet_name="$(tailscale status --json | ${jq}/bin/jq --raw-output '.MagicDNSSuffix' | ${coreutils}/bin/cut -d'.' -f1)"
    vpns+=("$tailnet_name")
  fi

  # And add any wireguard interfaces we're connected to.
  vpns+=($(${wireguard-tools}/bin/wg show interfaces))

  # Print!
  if [ ''${#vpns[@]} -eq 0 ]; then
    echo "N/A"
  else
    join_by ' • ' "''${vpns[@]}"
  fi
''
