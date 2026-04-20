#!/usr/bin/env bash
set -euo pipefail

# arch_for_me bootstrap — run on vanilla Arch:
#   curl -fsSL https://raw.githubusercontent.com/YOURUSER/arch_for_me/main/bootstrap.sh | bash

REPO="https://github.com/YOURUSER/arch_for_me.git"
DEST="$HOME/arch_for_me"

printf '\033[1;32m⚡ Bootstrapping arch_for_me\033[0m\n'

sudo pacman -Sy --noconfirm git

if [ -d "$DEST" ]; then
  git -C "$DEST" pull
else
  git clone "$REPO" "$DEST"
fi

chmod +x "$DEST/install.sh"
exec "$DEST/install.sh"
