function bm(){
  if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME=~/.config
  fi
  if [ "$1" = "ls" ]; then
    mkdir -p "$XDG_CONFIG_HOME/bm"
    touch "$XDG_CONFIG_HOME/bm/list.txt"
    cat "$XDG_CONFIG_HOME/bm/list.txt"
  elif [ "$1" = "go" ]; then
    while IFS=' ' read -r name path
    do
      if [ "$2" = "$name" ]; then
        cd "$path" || return 1
        echo "Successful go to bookmark: $name($path)"
        return 0
      fi
    done < "$XDG_CONFIG_HOME/bm/list.txt"
    echo "Not found bookmark: $2"
    return 1
  elif [ "$1" = "add" ]; then
    echo "$2 $(pwd)" >> "$XDG_CONFIG_HOME/bm/list.txt"
    echo "Successful add bookmark: $2($(pwd))"
  elif [ "$1" = "del" ]; then
    if grep -q "$2" "$XDG_CONFIG_HOME/bm/list.txt"; then
      grep -v "$2" "$XDG_CONFIG_HOME/bm/list.txt" > "$XDG_CONFIG_HOME/bm/tmp.txt"
      mv "$XDG_CONFIG_HOME/bm/tmp.txt" "$XDG_CONFIG_HOME/bm/list.txt"
      echo "Successful delete bookmark: $2"
      return 0
    else
      echo "Bookmark not found: $2"
      return 1
    fi
  else
    echo invalid subcommand
    return 1
  fi
  return 0
}

