# Powerlevel10k instant prompt redirects stdin/stdout during init and injects
# ANSI sequences that collide with VS Code's Terminal Shell Integration API
# (and Claude Code's terminal parsing) — skip it entirely inside VS Code's
# integrated terminal; keep the speed win everywhere else.
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
elif [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  aws
  docker
  docker-compose
  git
  kubectl
  minikube
  python
  teleport
  terraform
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
# Vault lives on hollowtree (CT115, homelab/vault) since 2026-10-16, not in a
# Docker container on the laptop. TLS with a private CA: copy it once per Mac,
#   ssh root@hollowtree 'pct exec 115 -- cat /opt/vault/tls/ca.crt' > ~/.config/vault/ca.pem
export VAULT_ADDR='https://vault.localdomain:8200'
export VAULT_CACERT="$HOME/.config/vault/ca.pem"
export PATH="$PATH:$HOME/bin"
export PATH="$HOME/.local/bin:$PATH"

# Personal aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Personal functions (see dotfiles/functions/*.zsh)
if [[ -L "$HOME/.zshrc" ]]; then
  export DOTFILES="$(cd "$(dirname "$(readlink "$HOME/.zshrc")")" && pwd)"
  for func_file in "$DOTFILES"/functions/*.zsh(N); do
    source "$func_file"
  done
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zoxide: frecency-based `cd` (use `z <partial-name>`)
command -v zoxide > /dev/null && eval "$(zoxide init zsh)"

# direnv: per-project env loading via .envrc
command -v direnv > /dev/null && eval "$(direnv hook zsh)"

# fzf: fuzzy history/file search (Ctrl-R, Ctrl-T, Alt-C)
# Ctrl-R matches exact substrings ("az" won't hit every a…z line);
# prefix a term with ' to get fuzzy matching back for that query.
export FZF_CTRL_R_OPTS="--exact"
command -v fzf > /dev/null && eval "$(fzf --zsh)"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Shell integration for VS Code
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Keep the Teleport client-tools pin in step with the primary cluster, at most
# once a day and always in the background -- this must never add latency to a
# shell, and an unreachable cluster must never block one. See .zshenv.
() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/teleport/tools-version"
  local -a fresh
  fresh=( ${cache}(Nmh-24) )          # exists and modified within 24h
  if (( ! $#fresh )) && command -v teleport-tools-sync >/dev/null 2>&1; then
    (teleport-tools-sync >/dev/null 2>&1 &)
  fi
}

# Machine/account-specific overrides that shouldn't be public (see .zshrc.local.example)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
