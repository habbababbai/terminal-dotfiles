# 99-local — machine-specific overrides, loaded last. local.zsh is created once
# from a starter template by chezmoi and then never touched again (create_ prefix),
# so edit it freely; it is not tracked in the repo.

[[ -r "$HOME/.config/zsh/local.zsh" ]] && source "$HOME/.config/zsh/local.zsh"
