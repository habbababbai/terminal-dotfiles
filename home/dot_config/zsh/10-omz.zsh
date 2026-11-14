# 10-omz — oh-my-zsh + plugins. oh-my-zsh and every custom plugin are cloned
# by chezmoi (.chezmoiexternal.toml) and refreshed by `chezmoi update`.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""                           # prompt is starship (20-tools)
zstyle ':omz:update' mode disabled     # chezmoi refreshes omz; avoid two updaters

# zsh-completions must be on fpath before omz runs compinit (not loaded as a plugin).
fpath+=("${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions/src")

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

plugins=(
  git
  fzf-tab                              # after compinit, before autosuggestions
  zsh-shift-select
  zsh-autosuggestions
  zsh-you-should-use
  forgit
  colored-man-pages
  extract
  sudo
  copypath
  copybuffer
  zsh-syntax-highlighting              # must precede history-substring-search
  history-substring-search
)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"   # runs compinit once
