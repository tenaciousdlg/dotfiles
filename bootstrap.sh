#!/usr/bin/env bash
# Symlinks these dotfiles into $HOME, backing up anything that isn't
# already a symlink into this repo. Safe to re-run.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dest="$2"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return
  fi

  if [ -e "$dest" ]; then
    echo "Backing up existing $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -s "$src" "$dest"
  echo "Linked $dest -> $src"
}

link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
link "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

mkdir -p "$HOME/bin"
for f in "$DOTFILES_DIR"/bin/*; do
  link "$f" "$HOME/bin/$(basename "$f")"
done

echo "Done. Restart your shell or run: source ~/.zshrc"
