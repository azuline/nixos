{ pkgs }:

pkgs.writeScriptBin "bar-vpn" ''
  ${pkgs.wireguard-tools}/bin/wg show interfaces | ${pkgs.gnused}/bin/sed 's/ / • /g'
''
