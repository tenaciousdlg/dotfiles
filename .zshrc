# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  aws
  git
  kubectl
  minikube
  python
  terraform
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export VAULT_ADDR='http://127.0.0.1:8200'
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

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Shell integration for VS Code
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
