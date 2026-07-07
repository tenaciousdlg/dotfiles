# dotfiles

Personal zsh setup: oh-my-zsh + powerlevel10k, aliases, functions, and small
CLI tools. `bootstrap.sh` symlinks everything into `$HOME` so this repo and
the live config are always the same file — no manual copy/paste to fall out
of sync.

## Layout

- `.zshrc`, `.aliases`, `.gitconfig`, `.vimrc`, `.p10k.zsh`, `gitignore_global` (→ `~/.gitignore`) — symlinked directly into `$HOME`
- `vscode/settings.json` — symlinked to VS Code's User settings (macOS path; skipped if VS Code isn't installed)
- `.zshrc.local.example` — template for machine/account-specific values that shouldn't be public (real file lives at `~/.zshrc.local`, gitignored, sourced automatically if present)
- `functions/*.zsh` — sourced automatically by `.zshrc`
- `bin/*` — symlinked into `~/bin`
- `templates/` — reusable snippets to copy into other projects (not symlinked); see `templates/direnv-vault/README.md`

## Tools this config expects

`brew install zoxide direnv kubectx fzf` — frecency-based `cd` (`z`), per-project
env loading, kube context/namespace switching (`kctx`/`kns`), and fuzzy
history/file search (Ctrl-R/Ctrl-T/Alt-C). All four are hooked into `.zshrc`
behind `command -v` checks, so a machine without them just skips the hook.

## One-time CLI setup (not managed by bootstrap.sh)

Some tool state lives outside `$HOME`'s dotfiles and isn't symlinked, but is
worth reproducing on a fresh machine:

```bash
# Azure CLI: default output is raw JSON and prints experimental-command
# warnings on every call — table output + quieter logging matches how
# aws/gcloud output already behaves here.
az config set core.output=table
az config set core.only_show_errors=true
az config set core.collect_telemetry=no
```

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
