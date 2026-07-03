# dotfiles

Personal zsh setup: oh-my-zsh + powerlevel10k, aliases, functions, and small
CLI tools. `bootstrap.sh` symlinks everything into `$HOME` so this repo and
the live config are always the same file — no manual copy/paste to fall out
of sync.

## Layout

- `.zshrc`, `.aliases`, `.gitconfig`, `.vimrc`, `.p10k.zsh`, `gitignore_global` (→ `~/.gitignore`) — symlinked directly into `$HOME`
- `functions/*.zsh` — sourced automatically by `.zshrc`
- `bin/*` — symlinked into `~/bin`
- `templates/` — reusable snippets to copy into other projects (not symlinked); see `templates/direnv-1password/README.md`

## Tools this config expects

`brew install zoxide direnv kubectx fzf` — frecency-based `cd` (`z`), per-project
env loading, kube context/namespace switching (`kctx`/`kns`), and fuzzy
history/file search (Ctrl-R/Ctrl-T/Alt-C). All four are hooked into `.zshrc`
behind `command -v` checks, so a machine without them just skips the hook.

## Install

```bash
git clone git@github.com:tenaciousdlg/dotfiles.git ~/github/dotfiles
cd ~/github/dotfiles
./bootstrap.sh
source ~/.zshrc
```

Re-running `bootstrap.sh` is safe. Any existing file at a target path that
isn't already the expected symlink is backed up as `<file>.bak` before the
symlink is created.
