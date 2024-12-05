{ writeShellScriptBin }:

writeShellScriptBin "term-pass" ''
  export PATH="$HOME/.nix-profile/bin:$PATH"

  password_dir="''${PASSWORD_STORE_DIR:=$HOME/.password-store}"
  file=$(find "$password_dir" -type f -name '*.gpg' -printf '%P\n' | sed 's/.gpg$//' | fzf --layout=reverse)

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
      content="$(echo $password | tr -d '\n')"
  else
      content="$(echo $choice | awk -F': ' '{$1="";print substr($0,2)}' | tr -d '\n')"
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    echo "$content" | nohup pbcopy >/dev/null 2>&1
  else
    echo "$content" | nohup xclip -loops 0 -sel c >/dev/null 2>&1
  fi
''
