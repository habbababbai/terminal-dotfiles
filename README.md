# terminal-dotfiles

My terminal setup: **Ghostty + zsh + oh-my-zsh**, kept in sync between macOS
and Ubuntu with [chezmoi](https://www.chezmoi.io/).

| | |
|---|---|
| Terminal | [Ghostty](https://ghostty.org): custom GLSL shader chain (cursor smear → bloom → unfocused dim) |
| Theme | GitHub Dark across Ghostty, the prompt, micro, fzf and bat |
| Font | FiraCode Nerd Font Mono |
| Shell | zsh + oh-my-zsh, with fzf-tab, autosuggestions, syntax-highlighting, forgit, you-should-use, … |
| Prompt | oh-my-zsh [agnoster](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster), recoloured to GitHub Dark (`10-omz.zsh`) |
| History | [atuin](https://atuin.sh) on <kbd>Ctrl</kbd>+<kbd>R</kbd> |
| CLI | fzf (fd + bat preview), zoxide, eza, bat, ripgrep, lazygit, micro, mise |

## Install

**Fresh machine** (macOS or Ubuntu):

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/habbababbai/terminal-dotfiles/main/install.sh)"
```

**From a clone:**

```sh
git clone https://github.com/habbababbai/terminal-dotfiles.git && ./terminal-dotfiles/install.sh
```

You'll be asked for a git name and email, and whether you want the optional extra
CLI tools. Then the installer:

1. installs prerequisites: Xcode CLT on macOS; `zsh git curl build-essential …` via apt on Ubuntu
2. installs Homebrew (on Linux too) and runs `brew bundle` on [`packages/Brewfile`](packages/Brewfile)
3. clones oh-my-zsh and its plugins
4. writes every config file
5. on Linux, installs Ghostty (snap) and makes zsh the login shell
6. installs FiraCode Nerd Font if it isn't already there

## Daily use

```sh
chezmoi update            # pull the latest from the repo and apply
chezmoi edit ~/.zshrc     # edit the source copy of a managed file
chezmoi diff              # preview what apply would change
chezmoi apply             # write the changes
chezmoi cd                # open a shell in the repo (commit & push from there)
```

## Layout

```
.
├── install.sh                 bootstrap: installs chezmoi → init --apply
├── packages/
│   ├── Brewfile               core terminal stack (macOS + Linux)
│   └── Brewfile.extras        optional CLI tools (asked at init)
└── home/                      chezmoi source state (see .chezmoiroot)
    ├── .chezmoi.toml.tmpl     per-machine prompts: git identity, extras
    ├── .chezmoiexternal.toml  oh-my-zsh + plugins as git clones
    ├── .chezmoiscripts/       prereqs, brew bundle, login shell, Ghostty (Linux), font
    ├── dot_zshrc              short loader for ~/.config/zsh/NN-*.zsh
    ├── dot_zprofile           Homebrew shellenv (macOS / Linux)
    ├── dot_gitconfig.tmpl
    └── dot_config/
        ├── zsh/               00-path 10-omz 20-tools 30-aliases 40-functions 50-colors 99-local
        ├── ghostty/           config, platform.conf.tmpl (per-OS), shaders/, themes/
        ├── private_atuin/  mise/  micro/  git/
```

chezmoi naming: `dot_` → `.`, `private_` → mode 0600/0700, `create_` → written once and
never overwritten, `.tmpl` → rendered as a template.

## What stays out of the repo

Each machine gets a `~/.config/zsh/local.zsh`, created once from a starter template and
never touched again. It holds anything specific to that machine or personal: paths, work
env vars, hosts, account helpers. Git can likewise pull in `~/.config/git/local` for
per-machine `includeIf` identity rules. Neither file is tracked.

## Credits

- **GitHub Dark** Ghostty theme: colours from GitHub's
  [Primer](https://primer.style/) palette, via
  [iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes) (MIT)
- **micro colour scheme**: hand-mapped from the GitHub Dark theme above
- **zsh**: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and the plugins listed in
  [`.chezmoiexternal.toml`](home/.chezmoiexternal.toml), cloned at install time and
  not redistributed here
- **Font**: [FiraCode](https://github.com/tonsky/FiraCode), patched by
  [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) (OFL-1.1), downloaded at install time

## License

MIT. Third-party pieces listed above keep their own licenses.
