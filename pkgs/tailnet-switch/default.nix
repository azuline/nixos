{ writeShellScriptBin }:

writeShellScriptBin "tailnet-switch" ''
  set -euo pipefail

  current="$(tailscale switch --list | awk '{print $3}' | rg '\*' | sed 's/\*$//')"
  if [[ "$current" = "home" ]]; then
    tailscale switch work
  else
    tailscale switch home
  fi
''
