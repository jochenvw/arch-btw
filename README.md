# arch-btw

Omarchy-inspired Arch Linux (WSL2) setup. One script, done. Hackerman theme. 🐧

## Bootstrap (one-liner on vanilla Arch)

No dependencies needed — `curl` ships with Arch base, and the bootstrap script installs `git` for you before cloning.

```bash
curl -fsSL https://raw.githubusercontent.com/jochenvw/arch-btw/master/bootstrap.sh | bash
```

Or do it yourself:

```bash
sudo pacman -S git
git clone https://github.com/jochenvw/arch-btw.git ~/arch-btw
cd ~/arch-btw && ./install.sh
exec zsh
```

## What you get

| Tool | What | Key |
|------|------|-----|
| zsh + starship | shell + prompt | — |
| zoxide + fzf | fuzzy `cd` / find | `cd <partial>` |
| lazygit | git TUI | `lg` |
| lazydocker | docker TUI | `ld` |
| neovim + LazyVim | editor | `v` |
| tmux | multiplexer | `Ctrl-a` prefix |
| zellij | modern multiplexer | `Alt` keys |
| github cli | `gh` | `gh` |
| copilot cli | AI in terminal | `ghcs` |
| btop | system monitor | `top` / `btop` |
| tty-clock | terminal clock | `clock` |
| go, python+uv, node+npm | languages | — |
| ripgrep, fd, bat, eza | better cli tools | — |

## Update everything

```bash
./update.sh
```

## Configs

Symlinked from `config/` — edit here, changes apply immediately.
