# 20-tools — tool init. Each is guarded so a missing tool never breaks the shell.
# Order matters: mise after brew PATH, atuin after fzf (both bind Ctrl+R).

(( $+commands[rbenv] ))    && eval "$(rbenv init - --no-rehash zsh)"
(( $+commands[mise] ))     && eval "$(mise activate zsh)"
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh)"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# bat — "ansi" draws with the terminal's 16 colours, so it follows the Ghostty theme
export BAT_THEME=ansi

# fzf — Ctrl+T files, Alt+C cd, **<TAB> completion — backed by fd, previewed by bat
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
  export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border'
  # GitHub Dark colours (ghostty/themes/GitHub-Dark); bg:-1 keeps the terminal background
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=fg:#c9d1d9,bg:-1,hl:#6ca4f8,fg+:#ffffff,bg+:#3b5070,hl+:#79c0ff,info:#e3b341,prompt:#6ca4f8,pointer:#f78166,marker:#56d364,spinner:#db61a2,header:#8b949e,border:#4d4d4d"
  eval "$(fzf --zsh)"
fi

# atuin owns Ctrl+R (history search)
(( $+commands[atuin] )) && eval "$(atuin init zsh)"
