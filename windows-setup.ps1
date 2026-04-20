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

# --- WSL2 ---
Info "🐧 Ensuring WSL2 is enabled"
$wslInstalled = wsl --list --quiet 2>&1
if ($LASTEXITCODE -ne 0) {
    Info "Installing WSL2"
    wsl --install --no-distribution
    Ok "WSL2 installed (reboot may be required before continuing)"
    Write-Host ""
    Write-Host "  ⚠️  If this is the first WSL install, reboot and re-run this script." -ForegroundColor Yellow
    Write-Host ""
} else {
    Skip "WSL2"
}

# --- Arch Linux on WSL2 ---
$archInstalled = wsl --list --quiet 2>&1 | Select-String -Pattern "Arch"
if (-not $archInstalled) {
    Info "🐧 Installing Arch Linux WSL2"
    $archDir = "$env:USERPROFILE\ArchWSL"
    $archZip = "$env:TEMP\Arch.zip"

    if (-not (Test-Path "$archDir\Arch.exe")) {
        # Download latest ArchWSL release
        Info "Downloading ArchWSL"
        $releases = Invoke-RestMethod "https://api.github.com/repos/yuk7/ArchWSL/releases/latest"
        $asset = $releases.assets | Where-Object { $_.name -match "Arch\.zip$" } | Select-Object -First 1
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archZip
        
        # Extract and install
        Info "Extracting to $archDir"
        New-Item -ItemType Directory -Path $archDir -Force | Out-Null
        Expand-Archive -Path $archZip -DestinationPath $archDir -Force
        Remove-Item $archZip -Force
    }

    Info "Registering Arch distro"
    Push-Location $archDir
    & .\Arch.exe
    Pop-Location
    Ok "Arch Linux WSL2"
} else {
    Skip "Arch Linux WSL2"
}

# --- Set Arch as default WSL distro ---
$distros = wsl --list --quiet 2>&1
if ($distros -match "Arch") {
    Info "Setting Arch as default WSL distro"
    wsl --set-default Arch
    Ok "Arch is default WSL distro"
}

# --- Done ---
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║                                           ║" -ForegroundColor Green
Write-Host "  ║   🎉  Windows side done!                  ║" -ForegroundColor Green
Write-Host "  ║                                           ║" -ForegroundColor Green
Write-Host "  ║   Next steps:                             ║" -ForegroundColor Green
Write-Host "  ║   1. Docker Desktop → Settings →           ║" -ForegroundColor Green
Write-Host "  ║      WSL Integration → enable Arch        ║" -ForegroundColor Green
Write-Host "  ║   2. Open Windows Terminal → Arch, run:   ║" -ForegroundColor Green
Write-Host "  ║                                           ║" -ForegroundColor Green
Write-Host "  ║      curl -fsSL https://raw.github        ║" -ForegroundColor Green
Write-Host "  ║      usercontent.com/jochenvw/arch-btw    ║" -ForegroundColor Green
Write-Host "  ║      /master/bootstrap.sh | bash          ║" -ForegroundColor Green
Write-Host "  ║                                           ║" -ForegroundColor Green
Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
