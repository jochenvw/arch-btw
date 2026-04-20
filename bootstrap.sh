#!/usr/bin/env bash
set -euo pipefail

# arch_for_me bootstrap — run on vanilla Arch:
#   curl -fsSL https://raw.githubusercontent.com/YOURUSER/arch_for_me/main/bootstrap.sh | bash

REPO="https://github.com/jochenvw/arch-btw.git"
DEST="$HOME/arch-btw"

printf '\033[1;32m⚡ Bootstrapping arch_for_me\033[0m\n'

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
exec "$DEST/install.sh"
