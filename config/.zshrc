# --- path ---
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"

# --- history ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt share_history hist_ignore_dups hist_ignore_space

# --- completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# --- prompt (starship) ---
eval "$(starship init zsh)"

# --- zoxide (fuzzy cd) ---
eval "$(zoxide init zsh --cmd cd)"

# --- fzf ---
source <(fzf --zsh)

# --- aliases ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat --style=plain'
alias lg='lazygit'
alias ld='lazydocker'
alias v='nvim'
alias clock='tclock'
alias timer='timr'
alias top='btop'
alias gs='git status -sb'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph -20'

# --- quick edit ---
alias ask='aichat'

# --- fastfetch on shell open ---
fastfetch 2>/dev/null
