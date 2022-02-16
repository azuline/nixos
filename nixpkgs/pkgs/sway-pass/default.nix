{ pkgs, ... }:

let
  sway-pass = pkgs.writeScriptBin "sway-pass" ''
    #!/usr/bin/env bash

    export PATH="$HOME/.nix-profile/bin:$PATH"

    file=$(find $HOME/.password-store -type f -name '*.gpg' -printf '%P\n' | sed 's/.gpg$//' | fzf --layout=reverse)

    if [[ -z "$file" ]]; then
        exit 1
    fi

    data="$(pass $file)" 2>&1

    ec=$?
    if [ "$ec" -ne 0 ]; then
        exit "$ec"
    fi

    password=$(echo "$data" | head -n1)
    fields=$(echo "$data" | tail -n+2)

    choice=$(printf "password: ********\n''${fields}\n" | fzf --layout=reverse)

    if [[ "$choice" = "password: ********" ]]; then
        echo $password | tr -d '\n' | wl-copy --trim-newline >/dev/null 2>&1
    else
        echo $choice | awk -F': ' '{$1="";print substr($0,2)}' | tr -d '\n' | wl-copy --trim-newline >/dev/null 2>&1
    fi
  '';
in
{
  home.packages = [ sway-pass ];
}
