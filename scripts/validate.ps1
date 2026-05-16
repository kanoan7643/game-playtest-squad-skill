param(
    [string]$SkillRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'

$SkillRoot = [System.IO.Path]::GetFullPath($SkillRoot).TrimEnd('\', '/')
$skillFile = Join-Path $SkillRoot 'SKILL.md'
$agentFile = Join-Path (Join-Path $SkillRoot 'agents') 'openai.yaml'
$installScript = Join-Path (Join-Path $SkillRoot 'scripts') 'install.ps1'

foreach ($path in @($skillFile, $agentFile, $installScript)) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing required file: $path"
    }
}

$skillContent = Get-Content -LiteralPath $skillFile -Raw
if ($skillContent -notmatch '(?ms)^---\s*.*?^---\s*') {
    throw 'SKILL.md is missing YAML frontmatter.'
}
if ($skillContent -notmatch '(?m)^name:\s*game-playtest-squad\s*$') {
    throw 'SKILL.md frontmatter name must be game-playtest-squad.'
}
if ($skillContent -notmatch '(?m)^description:\s*\S') {
    throw 'SKILL.md frontmatter description is missing.'
}

$agentContent = Get-Content -LiteralPath $agentFile -Raw
if ($agentContent -notmatch 'display_name:\s*"Game Playtest Squad"') {
    throw 'agents/openai.yaml display_name is missing or unexpected.'
}
if ($agentContent -notmatch [regex]::Escape('$game-playtest-squad')) {
    throw 'agents/openai.yaml default_prompt must mention $game-playtest-squad.'
}

$quickValidate = Join-Path (Join-Path (Join-Path (Join-Path (Join-Path $HOME '.codex') 'skills') '.system') 'skill-creator') 'scripts'
$quickValidate = Join-Path $quickValidate 'quick_validate.py'
if (Test-Path -LiteralPath $quickValidate) {
    $env:PYTHONUTF8 = '1'
    & python $quickValidate $SkillRoot
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
} else {
    Write-Host "Skipped Codex quick_validate.py; not found at $quickValidate"
}

Write-Host 'Skill project validation passed.'
