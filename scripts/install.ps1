param(
    [string]$SkillRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [string]$CodexSkillsRoot = (Join-Path (Join-Path $HOME '.codex') 'skills'),
    [string]$SkillName = 'game-playtest-squad',
    [switch]$Copy,
    [switch]$NoBackup,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

function Get-FullPath([string]$Path) {
    return [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
}

function Assert-ChildPath([string]$Parent, [string]$Child) {
    $parentFull = Get-FullPath $Parent
    $childFull = Get-FullPath $Child
    $prefix = $parentFull + [System.IO.Path]::DirectorySeparatorChar
    if ($childFull -ne $parentFull -and -not $childFull.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to write outside target root: $childFull"
    }
}

function Test-SameTarget([string]$ExistingPath, [string]$ExpectedTarget) {
    $item = Get-Item -LiteralPath $ExistingPath -Force
    if (-not ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        return $false
    }

    $expectedFull = Get-FullPath $ExpectedTarget
    $targets = @($item.Target) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    foreach ($target in $targets) {
        if ((Get-FullPath $target) -eq $expectedFull) {
            return $true
        }
    }
    return $false
}

function Remove-ExistingPath([string]$Path) {
    $item = Get-Item -LiteralPath $Path -Force
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        if ($item.PSIsContainer) {
            [System.IO.Directory]::Delete($Path)
        } else {
            [System.IO.File]::Delete($Path)
        }
    } else {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
}

$SkillRoot = Get-FullPath $SkillRoot
$CodexSkillsRoot = Get-FullPath $CodexSkillsRoot
$skillFile = Join-Path $SkillRoot 'SKILL.md'
if (-not (Test-Path -LiteralPath $skillFile)) {
    throw "Missing SKILL.md at skill root: $SkillRoot"
}

if (-not (Test-Path -LiteralPath $CodexSkillsRoot)) {
    if ($WhatIf) {
        Write-Host "Would create $CodexSkillsRoot"
    } else {
        New-Item -ItemType Directory -Path $CodexSkillsRoot -Force | Out-Null
    }
}

$linkPath = Join-Path $CodexSkillsRoot $SkillName
Assert-ChildPath $CodexSkillsRoot $linkPath

if (-not $Copy -and (Test-Path -LiteralPath $linkPath) -and (Test-SameTarget -ExistingPath $linkPath -ExpectedTarget $SkillRoot)) {
    Write-Host "Already linked $SkillName -> $SkillRoot"
    exit 0
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot = Join-Path $CodexSkillsRoot ".skill-backups\$timestamp"

if ($WhatIf) {
    if ($Copy) {
        Write-Host "Would copy $SkillRoot -> $linkPath"
    } else {
        Write-Host "Would link $linkPath -> $SkillRoot"
    }
    if ((Test-Path -LiteralPath $linkPath) -and -not $NoBackup) {
        Write-Host "Would backup existing non-link folder, if needed, under $backupRoot"
    }
    exit 0
}

if ((Test-Path -LiteralPath $linkPath) -and -not $NoBackup) {
    $existing = Get-Item -LiteralPath $linkPath -Force
    if (-not ($existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
        Copy-Item -LiteralPath $linkPath -Destination (Join-Path $backupRoot $SkillName) -Recurse -Force
    }
}

if (Test-Path -LiteralPath $linkPath) {
    Remove-ExistingPath $linkPath
}

if ($Copy) {
    Copy-Item -LiteralPath $SkillRoot -Destination $linkPath -Recurse -Force
    Write-Host "Copied $SkillName -> $linkPath"
} else {
    $platform = $PSVersionTable.Platform
    $itemType = if ([string]::IsNullOrWhiteSpace($platform) -or $platform -eq 'Win32NT') { 'Junction' } else { 'SymbolicLink' }
    New-Item -ItemType $itemType -Path $linkPath -Target $SkillRoot | Out-Null
    Write-Host "Linked $SkillName -> $SkillRoot"
}
