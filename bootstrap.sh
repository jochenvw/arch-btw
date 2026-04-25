#!/usr/bin/env bash
set -euo pipefail

# arch_for_me bootstrap — run on vanilla Arch:
#   curl -fsSL https://raw.githubusercontent.com/YOURUSER/arch_for_me/main/bootstrap.sh | bash

REPO="https://github.com/jochenvw/arch-btw.git"
DEST="$HOME/arch-btw"

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

printf '\033[1;32m⚡ Bootstrapping arch_for_me\033[0m\n'
printf '\033[1;36m  ⚙️  Environment: %s\033[0m\n' "$DETECTED_ENV"
printf '\033[1;36m  ⚙️  Detected default profile: %s\033[0m\n' "$DETECTED_PROFILE"
printf '\033[1;36m  ⚙️  Profile source: %s\033[0m\n' "$PROFILE_SOURCE"
printf '\033[1;34m  → Selected profile: %s\033[0m\n' "$PROFILE"

# use sudo if available, skip if already root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

$SUDO pacman -Sy --noconfirm git

if [ -d "$DEST" ]; then
  rm -rf "$DEST"
fi
git clone "$REPO" "$DEST"

chmod +x "$DEST/install.sh"
exec "$DEST/install.sh" "$PROFILE"
