# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme - using starship instead of oh-my-zsh themes
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
  zoxide
  macos
  brew
  github
  sudo
  copypath
  dirhistory
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ============================================
# User Configuration - Migrated from Fish
# ============================================

# Disable greeting
unsetopt AUTO_CD

# Environment variables
export EDITOR=nvim
export VISUAL=nvim
export CHARM_HOST="192.168.1.139"
export TERM_PROGRAM=ghostty

# PATH setup (prepend in priority order)
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.config/herd-lite/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.14/bin:$PATH"

# Tool initialization
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# NVM setup (lazy load for performance)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
# Auto-use LTS on first nvm invocation
__nvm_auto_use() {
  if [ -f ".nvmrc" ]; then
    nvm use >/dev/null 2>&1
  fi
}
add-zsh-hook chpwd __nvm_auto_use

# 1Password SSH Agent
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# ============================================
# Aliases
# ============================================

# SSH aliases
alias server="ssh root@192.168.1.139"
alias pico="ssh pico.sh"
alias texto="ssh texto-plano.xyz"
alias xinu="ssh m1n@xinu.me"
alias uber="ssh min@belinda.uberspace.de"

# Editor aliases
alias vi=nvim
alias vim=nvim

# Development aliases
alias explain="gh copilot explain"
alias suggest="gh copilot suggest"
alias jj-push="jj git push -c @-"
alias pa="hut paste"

# macOS package management
alias update="brew update && brew upgrade"
alias cleanup="brew cleanup && brew autoremove"

# Application aliases
alias cls=clear
alias radio="clear; mpv https://radio.m1n.land --volume=60"
alias note=dnote

# Zsh config
alias zshconfig="nvim ~/.zshrc"
alias zshreload="source ~/.zshrc"

# macOS specific
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias upgrade=update

# ============================================
# Custom Functions
# ============================================

# YouTube DL for Bandcamp with organized output
ytdlp-bandcamp() {
  yt-dlp -o "%(artist)s/%(album)s/%(title)s.%(ext)s" "$@"
}

# Remove brew package completely (including zap)
brew-remove() {
  brew uninstall --zap "$@"
}

# Create and cd to temporary directory
cdtmp() {
  local tmpdir
  tmpdir=$(mktemp -d -t cdtmp)
  cd "$tmpdir" || return
  echo "Created temporary directory: $tmpdir"
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

# ============================================
# Paste Functions (migrated from pastes.fish)
# ============================================

# Upload a paste (expires in 90 days)
paste() {
  if [ "$1" = "help" ]; then
    echo "Sube un archivo a pastes.sh. Expira en 90 días (por defecto)."
    echo "Uso: paste <fichero>"
  elif [ -n "$1" ]; then
    cat -- "$1" | ssh pastes.sh "$1"
  else
    echo "Error: Se requiere el nombre del fichero." >&2
    echo "Uso: paste <fichero>"
    return 1
  fi
}

# Upload a permanent paste (no expiration)
paste-p() {
  if [ "$1" = "help" ]; then
    echo "Sube un archivo a pastes.sh que no expira (permanente)."
    echo "Uso: paste-p <fichero>"
  elif [ -n "$1" ]; then
    cat -- "$1" | ssh pastes.sh "$1" expires=false
  else
    echo "Error: Se requiere el nombre del fichero." >&2
    echo "Uso: paste-p <fichero>"
    return 1
  fi
}

# Upload a hidden paste (expires in 90 days)
paste-h() {
  if [ "$1" = "help" ]; then
    echo "Sube un archivo oculto a pastes.sh. Expira en 90 días."
    echo "Uso: paste-h <fichero>"
  elif [ -n "$1" ]; then
    cat -- "$1" | ssh pastes.sh "$1" hidden=true
  else
    echo "Error: Se requiere el nombre del fichero." >&2
    echo "Uso: paste-h <fichero>"
    return 1
  fi
}

# Upload a permanent and hidden paste
paste-ph() {
  if [ "$1" = "help" ]; then
    echo "Sube un archivo oculto y permanente a pastes.sh."
    echo "Uso: paste-ph <fichero>"
  elif [ -n "$1" ]; then
    cat -- "$1" | ssh pastes.sh "$1" expires=false hidden=true
  else
    echo "Error: Se requiere el nombre del fichero." >&2
    echo "Uso: paste-ph <fichero>"
    return 1
  fi
}

# Download a paste from pastes.sh
pasteget() {
  if [ "$1" = "help" ]; then
    echo "Descarga (get) un archivo/paste desde pastes.sh."
    echo "Uso: pasteget <ruta-remota>"
  elif [ -n "$1" ]; then
    rsync "pastes.sh:/$1" .
  else
    echo "Error: Se requiere la ruta remota." >&2
    echo "Uso: pasteget <ruta-remota>"
    return 1
  fi
}

# List pastes on the server
pastels() {
  if [ "$1" = "help" ]; then
    echo "Lista (ls) los archivos/pastes en el servidor pastes.sh."
    echo "Uso: pastels"
  elif [ -n "$1" ]; then
    echo "Error: pastels no admite argumentos." >&2
    echo "Uso: pastels"
    return 1
  else
    echo ls | sftp -b - pastes.sh
  fi
}

# Mole shell completion (if available)
if command -v mole >/dev/null 2>&1; then
  eval "$(mole completion zsh 2>/dev/null)" 2>/dev/null || true
fi

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Ghostty shell integration
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
  ghostty_zsh="$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
  if [ -f "$ghostty_zsh" ]; then
    source "$ghostty_zsh"
  fi
fi
