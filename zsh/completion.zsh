function main () {
  typeset -A colors
  colors=(
    [default]=$'%{\e[0m%}'
    [red]=$'%{\e[1;31m%}'
    [green]=$'%{\e[1;32m%}'
    [yellow]=$'%{\e[1;33m%}'
    [blue]=$'%{\e[1;34m%}'
    [purple]=$'%{\e[1;35m%}'
    [light_blue]=$'%{\e[1;36m%}'
    [white]=$'%{\e[1;37m%}'
  )

  #== options ===#
  setopt auto_param_slash # 補完対象がディレクトリの場合は半角空白の代わりにスラッシュを挿入する
  setopt mark_dirs # globbingの結果得られたディレクトリ名にはスラッシュを末尾に追加する
  setopt list_types
  setopt auto_menu
  setopt auto_param_keys
  setopt interactive_comments
  setopt magic_equal_subst
  setopt always_last_prompt
  setopt print_eight_bit
  setopt extended_glob
  setopt globdots

  bindkey "^I" menu-complete

  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
  zstyle ':completion:*:messages' format "${colors[yellow]}%d${colors[default]}"
  zstyle ':completion:*:warnings' format "${colors[red]}No matches for:${colors[yellow]} %d${colors[default]}"
  zstyle ':completion:*:descriptions' format "${colors[yellow]}completing %B%d%b${colors[default]}"
  zstyle ':completion:*:corrections' format "${colors[yellow]}%B%d ${colors[red]}(errors: %e)%b${colors[default]}"
  zstyle ':completion:*:options' description 'yes'
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' list-separator '-->'
  zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
}

main

