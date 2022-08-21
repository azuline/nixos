{ pkgs, ... }:

let
  bar-loadavg = pkgs.writeScriptBin "bar-loadavg" ''
    #!/bin/sh

    /usr/bin/cat /proc/loadavg \
      | /usr/bin/awk '{print "  "$1"  "$2"  "$3"  "}'
  '';
in
{
  home.packages = [ bar-loadavg ];
}
