# 20-tools — tool init. Each is guarded so a missing tool never breaks the shell.
# Order matters: mise after brew PATH, atuin after fzf (both bind Ctrl+R).

(( $+commands[rbenv] ))    && eval "$(rbenv init - --no-rehash zsh)"
(( $+commands[mise] ))     && eval "$(mise activate zsh)"
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# fzf — Ctrl+T files, Alt+C cd, **<TAB> completion — backed by fd, previewed by bat
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
  export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border'
  eval "$(fzf --zsh)"
fi

# atuin owns Ctrl+R (history search)
(( $+commands[atuin] )) && eval "$(atuin init zsh)"
