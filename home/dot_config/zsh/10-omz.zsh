# 10-omz — oh-my-zsh + plugins. oh-my-zsh and every custom plugin are cloned
# by chezmoi (.chezmoiexternal.toml) and refreshed by `chezmoi update`.

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"                   # powerline prompt (user@host › dir › git)

# agnoster colours — GitHub Dark (ghostty/themes/GitHub-Dark) instead of the
# theme's stock ANSI black/blue/green/yellow. Must be set before omz loads.
# Dark text on light segments, light text on dark ones; all ≥ 4.5:1 contrast.
AGNOSTER_CONTEXT_BG='#30363d'  AGNOSTER_CONTEXT_FG='#c9d1d9'   # user@host
AGNOSTER_DIR_BG='#6ca4f8'      AGNOSTER_DIR_FG='#101216'       # path
AGNOSTER_GIT_CLEAN_BG='#56d364' AGNOSTER_GIT_CLEAN_FG='#101216'
AGNOSTER_GIT_DIRTY_BG='#e3b341' AGNOSTER_GIT_DIRTY_FG='#101216'
AGNOSTER_STATUS_BG='#30363d'   AGNOSTER_STATUS_FG='#c9d1d9'    # ✘ ⚡ ⚙ symbols
AGNOSTER_STATUS_RETVAL_FG='#f78166'
AGNOSTER_STATUS_ROOT_FG='#e3b341'
AGNOSTER_STATUS_JOB_FG='#6ca4f8'
AGNOSTER_VENV_BG='#3b5070'     AGNOSTER_VENV_FG='#ffffff'
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
