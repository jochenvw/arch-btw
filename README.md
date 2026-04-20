# arch_for_me

Omarchy-inspired Arch Linux (WSL2) setup. One script, done.

## Bootstrap (one-liner on vanilla Arch)

```bash
curl -fsSL https://raw.githubusercontent.com/YOURUSER/arch_for_me/main/bootstrap.sh | bash
```

Or manually:

```bash
sudo pacman -S git
git clone https://github.com/YOURUSER/arch_for_me.git ~/arch_for_me
cd ~/arch_for_me && ./install.sh
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
