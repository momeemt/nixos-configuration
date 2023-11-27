function bm(){
  if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME=~/.config
  fi
  if [ "$1" = "ls" ]; then
    mkdir -p "$XDG_CONFIG_HOME/bm"
    touch "$XDG_CONFIG_HOME/bm/list.txt"
    while read -r line
    do
      echo "$line"
    done < "$XDG_CONFIG_HOME/bm/list.txt"
  elif [ "$1" = "go" ]; then
    while read -r line
    do
      echo "$line" | IFS=' ' read -r name path
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
    while IFS=' ' read -r name path
    do
      if [ "$2" = "${name}" ]; then
        sed -i -e "/${name}/d" "$XDG_CONFIG_HOME"/bm/list.txt
        echo "Successful delete bookmark: $name($path)"
        return 0
      fi
    done < "$XDG_CONFIG_HOME"/bm/list.txt
    return 1
  else
    echo invalid subcommand
    return 1
  fi
  return 0
}
