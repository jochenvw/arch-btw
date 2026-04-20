# arch-btw

Omarchy-inspired dev machine setup. Fresh Windows 11 → fully loaded in two scripts. Hackerman theme. 🐧

## Step 1: Windows (PowerShell as Admin)

```powershell
irm https://raw.githubusercontent.com/jochenvw/arch-btw/master/windows-setup.ps1 | iex
```

Installs: Git, GitHub CLI, Copilot CLI, VS Code Insiders, Docker Desktop, Go, Python, Node.js, Azure CLI/azd/Functions, PowerShell 7, Brave, 7-Zip, FastStone Capture, Dev Tunnels, Foundry Local, Windows Terminal.

## Step 2: Arch WSL2 (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/jochenvw/arch-btw/master/bootstrap.sh | bash
```

No dependencies needed — bootstrap installs `git` for you.

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

## Docker (WSL2)

If you use Docker Desktop on Windows, enable your Arch distro:

**Docker Desktop → Settings → Resources → WSL Integration** → toggle on your Arch distro → Apply & Restart.

Then `docker` and `lazydocker` just work — no daemon needed inside WSL.

## Windows Terminal (hackerman colors)

To get the full hackerman look, add the theme to Windows Terminal:

1. Open **Windows Terminal → Settings → Open JSON file**
2. Find the `"schemes"` array
3. Paste the contents of `config/windows-terminal-hackerman.json` into it
4. Set your Arch profile's `"colorScheme"` to `"Hackerman"`

## Update everything

```bash
./update.sh
```

## Configs

Symlinked from `config/` — edit here, changes apply immediately.
