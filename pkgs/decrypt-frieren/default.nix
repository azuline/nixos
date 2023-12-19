{ writeShellScriptBin }:

writeShellScriptBin "decrypt-frieren" ''
  #!/usr/bin/env bash

  printf "waiting for stage 1 to become available.."
  while ! timeout 2 ping -c 1 -n 147.135.10.32 &> /dev/null
  do
      printf "%c" "."
  done

  echo
  echo "-----"
  echo "stage 1 available, ssh-ing to decrypt"
  ssh root@147.135.10.32 -p 2222
''
