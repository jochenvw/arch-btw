#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

DETECTED_ENV="unknown"
if command -v omarchy >/dev/null 2>&1; then
  DETECTED_ENV="omarchy (omarchy command found)"
  DETECTED_PROFILE="home"
elif pacman -Q omarchy-keyring >/dev/null 2>&1; then
  DETECTED_ENV="omarchy (omarchy-keyring package found)"
  DETECTED_PROFILE="home"
else
  DETECTED_ENV="vanilla arch (no omarchy markers found)"
  DETECTED_PROFILE="work"
fi

if [ -n "${1:-}" ]; then
  PROFILE="$1"
  PROFILE_SOURCE="cli argument"
elif [ -n "${ARCH_BTW_PROFILE:-}" ]; then
  PROFILE="$ARCH_BTW_PROFILE"
  PROFILE_SOURCE="ARCH_BTW_PROFILE env var"
else
  PROFILE="$DETECTED_PROFILE"
  PROFILE_SOURCE="auto-detected from environment"
fi

case "$PROFILE" in
  work|home) ;;
  *)
    printf '\033[1;31m  ❌ Invalid profile "%s". Use "work" or "home".\033[0m\n' "$PROFILE"
    exit 1
    ;;
esac

# --- helpers ---
info()  { printf '\033[1;34m  → %s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m  ✅ %s\033[0m\n' "$*"; }
skip()  { printf '\033[1;33m  ⏭️  %s (already installed)\033[0m\n' "$*"; }
step()  { printf '\033[1;36m  ⚙️  %s\033[0m\n' "$*"; }

install_aur_any() {
  local label="$1"
  shift
  local pkg
  for pkg in "$@"; do
    if $AS_BUILD yay -S --needed --noconfirm "$pkg" && pacman -Q "$pkg" >/dev/null 2>&1; then
      ok "$label ($pkg)"
      return 0
    fi
  done
  printf '\033[1;31m  ❌ Failed to install %s (tried: %s)\033[0m\n' "$label" "$*"
  return 1
}

install_pkg_any() {
  local label="$1"
  shift
  local pkg
  for pkg in "$@"; do
    if pacman -Q "$pkg" >/dev/null 2>&1; then
      skip "$label ($pkg)"
      return 0
    fi
  done
  for pkg in "$@"; do
    if $SUDO pacman -S --needed --noconfirm "$pkg" >/dev/null 2>&1 && pacman -Q "$pkg" >/dev/null 2>&1; then
      ok "$label ($pkg)"
      return 0
    fi
  done
  install_aur_any "$label" "$@"
}

install_aur_with_retry() {
  local pkg="$1"
  local attempts=0
  until [ "$attempts" -ge 3 ]; do
    if $AS_BUILD yay -S --needed --noconfirm "$pkg"; then
      return 0
    fi
    attempts=$((attempts + 1))
    step "Retrying $pkg from AUR ($attempts/3)"
    sleep 2
  done
  return 1
}

printf '\033[1;32m
    ╔═══════════════════════════════════════════╗
    ║                                           ║
    ║   arch-btw                                ║
    ║                                           ║
    ║   ░█▀█░█▀▄░█▀▀░█░█░░░█▀▄░▀█▀░█░█░         ║
    ║   ░█▀█░█▀▄░█░░░█▀█░░░█▀▄░░█░░█▄█░         ║
    ║   ░▀░▀░▀░▀░▀▀▀░▀░▀░░░▀▀░░░▀░░▀░▀░         ║
    ║                                           ║
    ║   hackerman edition                       ║
    ║                                           ║
    ╚═══════════════════════════════════════════╝
\033[0m\n'

info "Using profile: $PROFILE"
step "Environment: $DETECTED_ENV"
step "Detected default profile: $DETECTED_PROFILE"
step "Profile source: $PROFILE_SOURCE"

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

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
  github-cli git-lfs \
  btop fastfetch tree-sitter-cli luarocks \
  man-db htop jq yq
ok "pacman packages"

BUILD_USER="builder"
AS_BUILD=""
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

if command -v git-credential-manager >/dev/null 2>&1; then
  skip "git credential manager"
elif $SUDO pacman -S --needed --noconfirm git-credential-manager && command -v git-credential-manager >/dev/null 2>&1; then
  ok "git credential manager (pacman)"
elif install_aur_with_retry git-credential-manager && command -v git-credential-manager >/dev/null 2>&1; then
  ok "git credential manager (AUR)"
else
  printf '\033[1;31m  ❌ Failed to install git credential manager\033[0m\n'
  exit 1
fi

info "📦 Installing common extra tools"
install_pkg_any "Lazygit" lazygit
install_pkg_any "Lazydocker" lazydocker lazydocker-bin
install_pkg_any "Aichat" aichat
install_pkg_any "Timr" timr clock-tui

if [ "$PROFILE" = "work" ]; then
  info "📦 Installing work profile packages"
  install_pkg_any "Azure CLI" azure-cli
  install_pkg_any "Azure Dev CLI" azd-bin azd
fi

if [ "$PROFILE" = "home" ]; then
  info "📦 Installing home profile packages"
  install_pkg_any "Google Cloud CLI" google-cloud-cli google-cloud-cli-bin
  install_pkg_any "Cursor CLI" cursor-bin cursor
fi

if ! command -v uv &>/dev/null; then
  info "🐍 Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ok "uv"
else
  skip "uv"
fi

if [ "$PROFILE" = "work" ]; then
  if ! command -v gh-copilot &>/dev/null && ! gh copilot --version &>/dev/null 2>&1; then
    info "🤖 Installing GitHub Copilot CLI"
    curl -fsSL https://gh.io/copilot-install | bash
    ok "copilot cli"
  else
    skip "copilot cli"
  fi
fi

NVIM_DIR="$HOME/.config/nvim"
if [ "$PROFILE" = "work" ]; then
  if [ ! -d "$NVIM_DIR/lua" ]; then
    info "📝 Setting up LazyVim"
    rm -rf "$NVIM_DIR"
    git clone https://github.com/LazyVim/starter "$NVIM_DIR"
    rm -rf "$NVIM_DIR/.git"
    ok "lazyvim"
  else
    skip "lazyvim"
  fi
else
  step "Skipping LazyVim bootstrap on home profile"
fi

if [ -t 0 ] && [ "$SHELL" != "$(which zsh)" ]; then
  info "🐚 Setting zsh as default shell"
  chsh -s "$(which zsh)"
  ok "zsh default"
elif [ "$SHELL" = "$(which zsh)" ]; then
  skip "zsh default"
else
  step "Skipping default shell change (non-interactive run)"
fi

if [ "$PROFILE" = "work" ]; then
  info "🔗 Linking config files (work profile)"
  mkdir -p "$HOME/.config"

  ln -sf "$SCRIPT_DIR/config/.zshrc" "$HOME/.zshrc"
  ln -sf "$SCRIPT_DIR/config/starship.toml" "$HOME/.config/starship.toml"
  ln -sf "$SCRIPT_DIR/config/.tmux.conf" "$HOME/.tmux.conf"
  mkdir -p "$HOME/.config/zellij"
  ln -sf "$SCRIPT_DIR/config/zellij.kdl" "$HOME/.config/zellij/config.kdl"

  mkdir -p "$NVIM_DIR/lua/plugins"
  mkdir -p "$NVIM_DIR/lua/config"
  ln -sf "$SCRIPT_DIR/config/nvim/lua/config/lazy.lua" "$NVIM_DIR/lua/config/lazy.lua"
  ln -sf "$SCRIPT_DIR/config/nvim/lua/plugins/colorscheme.lua" "$NVIM_DIR/lua/plugins/colorscheme.lua"
  ln -sf "$SCRIPT_DIR/config/nvim/lua/plugins/lang.lua" "$NVIM_DIR/lua/plugins/lang.lua"
  ln -sf "$SCRIPT_DIR/config/nvim/lua/plugins/editor.lua" "$NVIM_DIR/lua/plugins/editor.lua"

  mkdir -p "$HOME/.config/lazygit"
  ln -sf "$SCRIPT_DIR/config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

  mkdir -p "$HOME/.config/lazydocker"
  ln -sf "$SCRIPT_DIR/config/lazydocker/config.yml" "$HOME/.config/lazydocker/config.yml"

  mkdir -p "$HOME/.config/fastfetch"
  ln -sf "$SCRIPT_DIR/config/fastfetch.jsonc" "$HOME/.config/fastfetch/config.jsonc"

  ok "configs linked (work)"
else
  step "Skipping terminal/theme dotfile linking on home profile"
  mkdir -p "$NVIM_DIR/lua/plugins"
  HOME_LANG_PLUGIN_FILE="$NVIM_DIR/lua/plugins/arch_btw_lang.lua"
  if [ ! -e "$HOME_LANG_PLUGIN_FILE" ]; then
    ln -sf "$SCRIPT_DIR/config/nvim/lua/plugins/lang.lua" "$HOME_LANG_PLUGIN_FILE"
    ok "nvim language plugin hook linked (home)"
  else
    skip "nvim language plugin hook (home)"
  fi
fi

if ! gh auth status &>/dev/null 2>&1; then
  printf '\n\033[1;33m  ⚠️  Run "gh auth login" to authenticate GitHub CLI\033[0m\n'
fi

printf '\033[1;32m
    ╔═══════════════════════════════════════════╗
    ║                                           ║
    ║   Done. Profile: %-4s                     ║
    ║                                           ║
    ║   Restart your shell:  exec zsh          ║
    ║                                           ║
    ╚═══════════════════════════════════════════╝
\033[0m\n' "$PROFILE"
