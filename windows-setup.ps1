# ╔═══════════════════════════════════════════╗
# ║                                           ║
# ║   🪟  a r c h - b t w   (windows side)   ║
# ║                                           ║
# ║   ░█▀█░█▀▄░█▀▀░█░█░░░█▀▄░▀█▀░█░█░       ║
# ║   ░█▀█░█▀▄░█░░░█▀█░░░█▀▄░░█░░█▄█░       ║
# ║   ░▀░▀░▀░▀░▀▀▀░▀░▀░░░▀▀░░░▀░░▀░▀░       ║
# ║                                           ║
# ║   windows dev tools installer 🛠️          ║
# ║                                           ║
# ╚═══════════════════════════════════════════╝

#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Info($msg)  { Write-Host "  → $msg" -ForegroundColor Cyan }
function Ok($msg)    { Write-Host "  ✅ $msg" -ForegroundColor Green }
function Skip($msg)  { Write-Host "  ⏭️  $msg (already installed)" -ForegroundColor Yellow }

# --- Dev tools via winget ---
$packages = @(
    # Core dev
    @{ id = "Git.Git";                             name = "Git" }
    @{ id = "GitHub.cli";                          name = "GitHub CLI" }
    @{ id = "GitHub.Copilot.Prerelease";           name = "Copilot CLI" }
    @{ id = "Microsoft.VisualStudioCode.Insiders"; name = "VS Code Insiders" }
    @{ id = "Docker.DockerDesktop";                name = "Docker Desktop" }

    # Languages
    @{ id = "GoLang.Go";                           name = "Go" }
    @{ id = "PythonSoftwareFoundation.Python.3.13"; name = "Python 3.13" }
    @{ id = "OpenJS.NodeJS.22";                    name = "Node.js 22" }

    # Azure / Cloud
    @{ id = "Microsoft.Azd";                       name = "Azure Developer CLI" }
    @{ id = "Microsoft.AzureCLI";                  name = "Azure CLI" }
    @{ id = "Microsoft.Azure.FunctionsCoreTools";  name = "Azure Functions Core Tools" }
    @{ id = "Microsoft.devtunnel";                 name = "Dev Tunnels" }
    @{ id = "Microsoft.FoundryLocal";              name = "Foundry Local" }

    # Terminal / Shell
    @{ id = "Microsoft.WindowsTerminal";           name = "Windows Terminal" }
    @{ id = "Microsoft.PowerShell";                name = "PowerShell 7" }

    # Productivity
    @{ id = "Brave.Brave";                         name = "Brave Browser" }
    @{ id = "7zip.7zip";                           name = "7-Zip" }
    @{ id = "FastStone.Capture";                   name = "FastStone Capture" }
)

Info "📦 Installing dev tools via winget"
foreach ($pkg in $packages) {
    $installed = winget list --id $pkg.id --accept-source-agreements 2>&1
    if ($installed -match $pkg.id) {
        Skip $pkg.name
    } else {
        Info "Installing $($pkg.name)"
        winget install --id $pkg.id --accept-source-agreements --accept-package-agreements --silent
        Ok $pkg.name
    }
}

# --- WSL2 + Arch ---
Info "🐧 Ensuring WSL2 is enabled"
$wslInstalled = wsl --list --quiet 2>&1
if ($LASTEXITCODE -ne 0) {
    Info "Installing WSL2"
    wsl --install --no-distribution
    Ok "WSL2 (reboot may be required)"
} else {
    Skip "WSL2"
}

# --- Done ---
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║                                           ║" -ForegroundColor Green
Write-Host "  ║   🎉  Windows side done!                  ║" -ForegroundColor Green
Write-Host "  ║                                           ║" -ForegroundColor Green
Write-Host "  ║   Next steps:                             ║" -ForegroundColor Green
Write-Host "  ║   1. Install Arch Linux from MS Store     ║" -ForegroundColor Green
Write-Host "  ║      or: github.com/yuk7/ArchWSL          ║" -ForegroundColor Green
Write-Host "  ║   2. Docker Desktop → Settings →           ║" -ForegroundColor Green
Write-Host "  ║      WSL Integration → enable Arch        ║" -ForegroundColor Green
Write-Host "  ║   3. In Arch WSL, run:                    ║" -ForegroundColor Green
Write-Host "  ║      curl -fsSL https://raw.github        ║" -ForegroundColor Green
Write-Host "  ║      usercontent.com/jochenvw/arch-btw    ║" -ForegroundColor Green
Write-Host "  ║      /master/bootstrap.sh | bash          ║" -ForegroundColor Green
Write-Host "  ║                                           ║" -ForegroundColor Green
Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
