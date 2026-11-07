# Kratos Mini-PC setup preflight
# Downloads and verifies the published source package, installs prerequisites,
# installs locked dependencies, and runs the documented synthetic rehearsal.
# It does not configure production data, OAuth, Windows services, firewall, or remote access.

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$root = "C:\Kratos"
$zipName = "kratos-crm-minipc-server-source-2026-11-06-v2.zip"
$zipUrl = "https://github.com/FAM12345654/kratos-crm-minipc/raw/refs/heads/main/$zipName"
$expectedSha256 = "7BAEE5EAD83D3F48093080C39EAC95138EF58A31283156E2D5788A3987E27D75"
$zipPath = Join-Path $root $zipName
$serverPath = Join-Path $root "server-v2"

function Stop-WithMessage([string]$Message) {
    Write-Host ""
    Write-Host $Message -ForegroundColor Red
    Write-Host "Nothing in an existing Kratos server folder was deleted or overwritten." -ForegroundColor Yellow
    exit 1
}

try {
    New-Item -ItemType Directory -Path $root -Force | Out-Null

    if (Test-Path $serverPath) {
        Stop-WithMessage "The target folder already exists: $serverPath. Move it aside yourself if you want a separate clean extraction, then run this script again."
    }

    $nodeCommand = Get-Command node -ErrorAction SilentlyContinue
    $nodeVersion = $null
    if ($nodeCommand) {
        $nodeVersion = [version]((& node --version).Trim().TrimStart("v"))
    }

    if (-not $nodeVersion -or $nodeVersion -lt [version]"22.16.0") {
        $wingetCommand = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $wingetCommand) {
            Stop-WithMessage "Node.js 22.16 or newer is required, and winget is unavailable. Install Node.js LTS from https://nodejs.org, reopen PowerShell, and run this script again."
        }

        Write-Host "Installing Node.js LTS with Windows Package Manager..."
        & winget install --id OpenJS.NodeJS.LTS --exact --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            Stop-WithMessage "Node.js installation failed. Check the Windows Package Manager output, install Node.js LTS, then run this script again."
        }

        $candidatePaths = @(
            "$env:ProgramFiles\nodejs",
            "$env:LOCALAPPDATA\Programs\nodejs",
            "$env:APPDATA\npm"
        ) | Where-Object { Test-Path $_ }
        if ($candidatePaths) {
            $env:PATH = (($candidatePaths -join ";") + ";" + $env:PATH)
        }

        $nodeCommand = Get-Command node -ErrorAction SilentlyContinue
        if (-not $nodeCommand) {
            Stop-WithMessage "Node.js was installed, but this PowerShell session cannot find it. Close PowerShell, open it again, and run this script again."
        }
        $nodeVersion = [version]((& node --version).Trim().TrimStart("v"))
        if ($nodeVersion -lt [version]"22.16.0") {
            Stop-WithMessage "The installed Node.js version is too old. Install Node.js 22.16 or newer and run this script again."
        }
    }

    $pnpmCommand = Get-Command pnpm -ErrorAction SilentlyContinue
    $pnpmVersion = $null
    if ($pnpmCommand) {
        $pnpmVersion = [version]((& pnpm --version).Trim())
    }
    if (-not $pnpmVersion -or $pnpmVersion.Major -lt 11) {
        if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
            Stop-WithMessage "npm is unavailable. Repair the Node.js LTS installation, reopen PowerShell, and run this script again."
        }
        Write-Host "Installing pnpm 11..."
        & npm install --global pnpm@11
        if ($LASTEXITCODE -ne 0) {
            Stop-WithMessage "pnpm installation failed. Repair npm or install pnpm 11, then run this script again."
        }
    }

    Write-Host "Downloading the published Kratos source package..."
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
    $actualSha256 = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($actualSha256 -ne $expectedSha256) {
        Remove-Item -LiteralPath $zipPath -Force
        Stop-WithMessage "The downloaded archive did not match the published SHA-256. The archive was removed; do not run it."
    }

    New-Item -ItemType Directory -Path $serverPath | Out-Null
    Expand-Archive -LiteralPath $zipPath -DestinationPath $serverPath
    if (-not (Test-Path (Join-Path $serverPath "package.json"))) {
        Stop-WithMessage "The archive layout differs from the documented package. The files remain in $serverPath for inspection; no service was started."
    }

    Push-Location $serverPath
    try {
        Write-Host "Installing dependencies from the locked package manifest..."
        & pnpm install --frozen-lockfile
        if ($LASTEXITCODE -ne 0) {
            Stop-WithMessage "Dependency installation failed. Review the pnpm output. No service was started."
        }

        Write-Host "Running the synthetic rehearsal..."
        & node scripts/kratos-local-rehearsal.mjs
        if ($LASTEXITCODE -ne 0) {
            Stop-WithMessage "The synthetic rehearsal failed. Do not use this package with real customer data."
        }
    }
    finally {
        Pop-Location
    }

    Write-Host ""
    Write-Host "PREPARATION COMPLETE: package verified, dependencies installed, synthetic rehearsal passed." -ForegroundColor Green
    Write-Host "Source folder: $serverPath"
    Write-Host "Archive: $zipPath"
    Write-Host ""
    Write-Host "This is not a live server installation. Production database, OAuth, Windows service, HTTPS, and remote ChatGPT access are not configured by this package." -ForegroundColor Yellow
    Write-Host "Do not put real customer data into the local API until those items are implemented and reviewed."
}
catch {
    Stop-WithMessage ("Setup stopped: " + $_.Exception.Message)
}
