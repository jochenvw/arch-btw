# arch-btw

Terse bootstrap for two Arch targets:
- `work`: vanilla Arch/WSL + Azure/Copilot
- `home`: Omarchy + GCP/Cursor

## Install

Windows (PowerShell admin):
```powershell
irm https://raw.githubusercontent.com/jochenvw/arch-btw/master/windows-setup.ps1 | iex
```

Arch/Omarchy (auto-detect profile):
```bash
curl -fsSL https://raw.githubusercontent.com/jochenvw/arch-btw/master/bootstrap.sh | bash
```

Force profile:
```bash
curl -fsSL https://raw.githubusercontent.com/jochenvw/arch-btw/master/bootstrap.sh | bash -s -- work
curl -fsSL https://raw.githubusercontent.com/jochenvw/arch-btw/master/bootstrap.sh | bash -s -- home
```

## Profiles

- Auto-detect: Omarchy (`omarchy` command or `omarchy-keyring`) => `home`, else `work`
- Shared tools: zsh, starship, nvim/LazyVim, tmux, zellij, lazygit, lazydocker, btop, fastfetch, go, python+uv, node, `git-lfs`, `git-credential-manager`, `tree-sitter-cli`, `luarocks`
- Work-only: `az`, `azd`, `gh-copilot`
- Home-only: `gcloud`, `cursor`

## Notes

- `home` install is non-invasive: no terminal/theme dotfile overrides, no LazyVim bootstrap replacement
- `./install.sh` to reconcile local machine
- `./update.sh` to update packages/plugins
