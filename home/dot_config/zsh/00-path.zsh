# 00-path — PATH additions. Homebrew itself is set up in ~/.zprofile.

typeset -U path                        # dedupe entries

if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
export BUN_INSTALL="$HOME/.bun"

path=(
  "$HOME/.opencode/bin"
  "$BUN_INSTALL/bin"
  "$PNPM_HOME"
  $path
  "$HOME/.local/bin"                   # pipx, claude, personal scripts
  "$HOME/go/bin"                       # = $(go env GOPATH)/bin, without spawning go
)
path=(${^path}(N-/))                   # drop directories that don't exist on this machine
export PATH
