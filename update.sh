#!/usr/bin/env bash
set -euo pipefail

info()  { printf '\033[1;34m→ %s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m✓ %s\033[0m\n' "$*"; }

info "Updating pacman packages"
sudo pacman -Syu --noconfirm

info "Updating AUR packages"
yay -Syu --noconfirm

info "Updating uv"
uv self update 2>/dev/null || true

info "Updating LazyVim plugins"
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

info "Updating Copilot CLI"
gh extension upgrade --all 2>/dev/null || true

ok "Everything up to date"
