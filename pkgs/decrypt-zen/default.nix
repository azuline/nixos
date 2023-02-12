{ pkgs }:

pkgs.writeShellScriptBin "decrypt-zen" ''
  #!/usr/bin/env bash

  printf "waiting for stage 1 to become available.."
  while ! timeout 2 ping -c 1 -n 147.135.1.125 &> /dev/null
  do
      printf "%c" "."
  done

  echo
  echo "-----"
  echo "stage 1 available, ssh-ing to decrypt"
  ssh root@147.135.1.125 -p 2222
''
