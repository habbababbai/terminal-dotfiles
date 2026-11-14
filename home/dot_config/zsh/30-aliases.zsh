# 30-aliases — editor + modern CLI replacements (only when the tool exists).

if (( $+commands[micro] )); then
  export EDITOR=micro GIT_EDITOR=micro MICRO_TRUECOLOR=1
  alias vim='micro' vi='micro' nano='micro'
fi

(( $+commands[zoxide] )) && alias cd='z'

if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first'
  alias ll='eza -lag --git --group-directories-first'
  alias lt='eza --tree --level=2 --git-ignore'
fi

if (( $+commands[bat] )); then
  alias cat='bat --paging=never'       # `command cat` for the real one
  alias bathelp='bat --plain --language=help'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

alias ghostconfig='${EDITOR:-vi} ~/.config/ghostty/config'
