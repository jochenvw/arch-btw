# arch-btw 🐧

Fresh Win11 → fully loaded dev machine. Two one-liners. Hackerman theme.

## Install

**Windows** (PowerShell as Admin):
```powershell
irm https://raw.githubusercontent.com/jochenvw/arch-btw/master/windows-setup.ps1 | iex
```

**Arch WSL2** (in terminal):
```bash
curl -fsSL https://raw.githubusercontent.com/jochenvw/arch-btw/master/bootstrap.sh | bash
```

## What's in the box

**Windows**: Git, GitHub CLI, Copilot CLI, VS Code Insiders, Docker Desktop, Go, Python, Node.js, Azure CLI/azd/Functions, Dev Tunnels, Foundry Local, PowerShell 7, Brave, 7-Zip, FastStone Capture, WSL2 + Arch.

**Arch WSL2**: zsh, starship, zoxide, fzf, lazygit (`lg`), lazydocker (`ld`), neovim+LazyVim (`v`), tmux, zellij, btop, timr-tui (`clock` — pomodoro + timer), aichat (`ask`), Go, Python+uv, Node+npm, ripgrep, fd, bat, eza, fastfetch, GitHub Copilot CLI. All hackerman themed.

## Post-install

- **Docker**: Docker Desktop → Settings → Resources → WSL Integration → enable Arch
- **Terminal colors**: Add `config/windows-terminal-hackerman.json` to Windows Terminal schemes
- **Update everything**: `./update.sh`
- **Configs**: Symlinked from `config/` — edit in repo, changes apply immediately
