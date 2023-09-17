{ pkgs }:

pkgs.writeScriptBin "bar-vpn" ''
  out="$(${pkgs.wireguard-tools}/bin/wg show interfaces | ${pkgs.gnused}/bin/sed 's/ / • /g')"
  if [ -z "$out" ]; then
    echo "N/A"
  else
    echo "$out"
  fi
''
