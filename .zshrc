# --- Powerlevel10k instant prompt: keep at the very top ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Python paths
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# Optional while diagnosing (remove later if you like)
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# ----------------------------------------------------------

# Powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# History
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

# Keybindings (history search with ↑/↓)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- Completions (set fpath BEFORE compinit) ----
fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit
compinit -C         # (after fixing perms above; use -u only if you must)

# ---- Plugins/tools (after compinit) ----
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(zoxide init zsh)"

# Aliases
alias ls="eza --icons=always"
alias cd="z"        # Note: this overrides `cd -` behavior; remove if you rely on it

# Keep syntax highlighting LAST
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(/opt/homebrew/bin/brew shellenv)"
