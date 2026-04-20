#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- helpers ---
info()  { printf '\033[1;34m  → %s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m  ✅ %s\033[0m\n' "$*"; }
skip()  { printf '\033[1;33m  ⏭️  %s (already installed)\033[0m\n' "$*"; }
fail()  { printf '\033[1;31m  ❌ %s\033[0m\n' "$*"; exit 1; }

printf '\033[1;32m
    ╔═══════════════════════════════════════════╗
    ║                                           ║
    ║   🐧  a r c h - b t w                    ║
    ║                                           ║
    ║   ░█▀█░█▀▄░█▀▀░█░█░░░█▀▄░▀█▀░█░█░       ║
    ║   ░█▀█░█▀▄░█░░░█▀█░░░█▀▄░░█░░█▄█░       ║
    ║   ░▀░▀░▀░▀░▀▀▀░▀░▀░░░▀▀░░░▀░░▀░▀░       ║
    ║                                           ║
    ║   hackerman edition 💀                    ║
    ║                                           ║
    ╚═══════════════════════════════════════════╝
\033[0m\n'

# use sudo if available, skip if already root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# --- remove AWS copilot if installed ---
if command -v copilot &>/dev/null; then
  info "🗑️  Removing AWS Copilot (wrong one!)"
  $SUDO rm -f "$(which copilot)"
  ok "AWS Copilot removed"
fi

# --- pacman core packages ---
info "📦 Updating system & installing packages"
$SUDO pacman -Syu --noconfirm
$SUDO pacman -S --needed --noconfirm \
  base-devel git curl wget unzip openssh \
  zsh starship tmux zellij \
  neovim \
  fzf ripgrep fd bat eza zoxide \
  go python python-pip nodejs npm \
  gopls delve python-debugpy ruff \
  docker docker-compose \
  github-cli btop fastfetch \
  man-db htop jq yq
ok "pacman packages"

# --- build user for AUR (makepkg refuses root) ---
BUILD_USER="builder"
if [ "$(id -u)" -eq 0 ]; then
  if ! id "$BUILD_USER" &>/dev/null; then
    info "👷 Creating AUR build user"
    useradd -m "$BUILD_USER"
    echo "$BUILD_USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$BUILD_USER"
  fi
  AS_BUILD="sudo -u $BUILD_USER"
else
  AS_BUILD=""
fi

# --- yay (AUR helper) ---
if ! command -v yay &>/dev/null; then
  info "📦 Installing yay"
  tmp=$(mktemp -d)
  chmod 777 "$tmp"
  git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
  chmod -R 777 "$tmp/yay-bin"
  (cd "$tmp/yay-bin" && $AS_BUILD makepkg -si --noconfirm)
  rm -rf "$tmp"
  ok "yay"
else
  skip "yay"
fi

# --- AUR packages ---
info "📦 Installing AUR packages"
$AS_BUILD yay -S --needed --noconfirm lazygit lazydocker-bin tty-clock
ok "lazygit, lazydocker, tty-clock"

# --- uv (python) ---
if ! command -v uv &>/dev/null; then
  info "🐍 Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ok "uv"
else
  skip "uv"
fi

# --- GitHub Copilot CLI ---
if ! command -v gh-copilot &>/dev/null && ! gh copilot --version &>/dev/null 2>&1; then
  info "🤖 Installing GitHub Copilot CLI"
  curl -fsSL https://gh.io/copilot-install | bash
  ok "copilot cli"
else
  skip "copilot cli"
fi

# --- LazyVim ---
NVIM_DIR="$HOME/.config/nvim"
if [ ! -d "$NVIM_DIR/lua" ]; then
  info "📝 Setting up LazyVim"
  rm -rf "$NVIM_DIR"
  git clone https://github.com/LazyVim/starter "$NVIM_DIR"
  rm -rf "$NVIM_DIR/.git"
  ok "lazyvim"
else
  skip "lazyvim"
fi

# --- zsh as default shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
  info "🐚 Setting zsh as default shell"
  chsh -s "$(which zsh)"
  ok "zsh default"
else
  skip "zsh default"
fi

# --- symlink configs ---
info "🔗 Linking config files"
mkdir -p "$HOME/.config"

ln -sf "$SCRIPT_DIR/config/.zshrc"        "$HOME/.zshrc"
ln -sf "$SCRIPT_DIR/config/starship.toml"  "$HOME/.config/starship.toml"
ln -sf "$SCRIPT_DIR/config/.tmux.conf"     "$HOME/.tmux.conf"
mkdir -p "$HOME/.config/zellij"
ln -sf "$SCRIPT_DIR/config/zellij.kdl"    "$HOME/.config/zellij/config.kdl"

# btop hackerman theme
mkdir -p "$HOME/.config/btop/themes"
ln -sf "$SCRIPT_DIR/config/btop/btop.conf"                  "$HOME/.config/btop/btop.conf"
ln -sf "$SCRIPT_DIR/config/btop/themes/hackerman.theme"     "$HOME/.config/btop/themes/hackerman.theme"

# lazyvim config + hackerman colorscheme
mkdir -p "$NVIM_DIR/lua/plugins"
mkdir -p "$NVIM_DIR/lua/config"
ln -sf "$SCRIPT_DIR/config/nvim/lua/config/lazy.lua"         "$NVIM_DIR/lua/config/lazy.lua"
ln -sf "$SCRIPT_DIR/config/nvim/lua/plugins/colorscheme.lua" "$NVIM_DIR/lua/plugins/colorscheme.lua"
ln -sf "$SCRIPT_DIR/config/nvim/lua/plugins/lang.lua"        "$NVIM_DIR/lua/plugins/lang.lua"
ln -sf "$SCRIPT_DIR/config/nvim/lua/plugins/editor.lua"      "$NVIM_DIR/lua/plugins/editor.lua"

# lazygit hackerman theme
mkdir -p "$HOME/.config/lazygit"
ln -sf "$SCRIPT_DIR/config/lazygit/config.yml"    "$HOME/.config/lazygit/config.yml"

# lazydocker hackerman theme
mkdir -p "$HOME/.config/lazydocker"
ln -sf "$SCRIPT_DIR/config/lazydocker/config.yml"  "$HOME/.config/lazydocker/config.yml"

# fastfetch config
mkdir -p "$HOME/.config/fastfetch"
ln -sf "$SCRIPT_DIR/config/fastfetch.jsonc"  "$HOME/.config/fastfetch/config.jsonc"

ok "configs linked"

# --- gh cli auth reminder ---
if ! gh auth status &>/dev/null 2>&1; then
  printf '\n\033[1;33m  ⚠️  Run "gh auth login" to authenticate GitHub CLI\033[0m\n'
fi

# --- done ---
printf '\033[1;32m
    ╔═══════════════════════════════════════════╗
    ║                                           ║
    ║   🎉  All done! You use Arch btw.        ║
    ║                                           ║
    ║   Restart your shell:  exec zsh           ║
    ║                                           ║
    ╚═══════════════════════════════════════════╝
\033[0m\n'
