{ pkgs }:

pkgs.writeScriptBin "bar-vpn" ''
  /usr/bin/wg show interfaces | ${pkgs.gnused}/bin/sed 's/ / • /g'
''
