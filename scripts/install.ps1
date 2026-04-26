param(
    [string]$TargetProject = ".",
    [switch]$All,
    [switch]$Claude,
    [switch]$OpenCode,
    [switch]$Copilot,
    [string]$SkillsDir = ".agentic-dev-system/skills",
    [switch]$Force,
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Show-Usage {
    @"
Install Agentic Dev System skills at project level.

Usage:
  ./scripts/install.ps1 [-TargetProject <path>] [options]

Options:
  -All              Install routing for Claude, OpenCode, and GitHub Copilot (default)
  -Claude           Install Claude project instructions
  -OpenCode         Install OpenCode project instructions
  -Copilot          Install GitHub Copilot project instructions
  -SkillsDir DIR    Project-relative skill install directory (default: .agentic-dev-system/skills)
  -Force            Replace existing installed skill files
  -Help             Show help

Examples:
  ./scripts/install.ps1 -TargetProject C:\path\to\project
  ./scripts/install.ps1 -TargetProject . -Claude -OpenCode
  ./scripts/install.ps1 -TargetProject C:\app -SkillsDir .claude/skills -Force

Offline: this script only copies local files. It does not use npm, npx, curl, or network access.
"@
}

function Fail($Message) {
    Write-Error "ERROR: $Message"
    exit 1
}

function Write-Info($Message) {
    Write-Output $Message
}

if ($Help) {
    Show-Usage
    exit 0
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..")
$SourceSkillsDir = Join-Path $RepoRoot "skills"
$SourceRegistryFile = Join-Path $SourceSkillsDir "registry.json"

if (-not (Test-Path -LiteralPath $SourceSkillsDir -PathType Container)) {
    Fail "skills directory not found: $SourceSkillsDir"
}

$ExplicitTargets = $Claude -or $OpenCode -or $Copilot -or $All
if (-not $ExplicitTargets) {
    $Claude = $true
    $OpenCode = $true
    $Copilot = $true
}
elseif ($All) {
    $Claude = $true
    $OpenCode = $true
    $Copilot = $true
}

if ([System.IO.Path]::IsPathRooted($SkillsDir)) {
    Fail "-SkillsDir must be project-relative, got: $SkillsDir"
}

$SkillParts = $SkillsDir -split '[\\/]+'
if ($SkillParts -contains "..") {
    Fail "-SkillsDir must not contain '..', got: $SkillsDir"
}

if (-not (Test-Path -LiteralPath $TargetProject -PathType Container)) {
    Fail "target project does not exist: $TargetProject"
}

$TargetProject = (Resolve-Path $TargetProject).Path
$DestSkillsDir = Join-Path $TargetProject $SkillsDir

$MarkerBegin = "<!-- agentic-dev-system:begin -->"
$MarkerEnd = "<!-- agentic-dev-system:end -->"

$RoutingBlock = @"
$MarkerBegin
## Agentic Dev System Skills

Project-level skills are installed in ``$SkillsDir``.

When the user's request matches one of these workflows, use the matching skill before answering directly:

- New feature, vague product request, multi-step build -> ``start-work``
- Requirements or design already exist -> ``plan-work``
- Written implementation plan ready -> ``execute-work``
- New behavior, bug fix, or behavior refactor -> ``tdd-work``
- Bug, failing test, regression, production issue -> ``debug-root-cause``
- Any done/fixed/passing/ready claim -> ``verify-work``
- Refactor, simplify, reduce complexity -> ``simplify-work``
- Understand, document, or remember code/project knowledge -> ``capture-learning``
- Received code review feedback -> ``review-feedback``
- Review README, install docs, guides, or skill docs -> ``docs-review``
- Branch ready for final review, commit, or PR -> ``finish-work``
- Create or revise skills -> ``writing-skills``

Golden path: ``start-work -> plan-work -> execute-work -> verify-work -> capture-learning -> finish-work``.

Fast path: for tiny low-risk tasks, make the change, run ``verify-work``, and report evidence. Do not create lifecycle docs for typo-level work.

Core rules:

- No fixes without root cause for bugs.
- No completion claims without fresh command output.
- No production code for behavior changes without a failing test first unless explicitly approved.
- Spec compliance review comes before code quality review.
- Store only reusable, verified knowledge in local Markdown. Never store secrets, transcripts, or one-off progress.
- Some duplication beats the wrong abstraction.
$MarkerEnd
"@

function Ensure-ParentDir($Path) {
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent -PathType Container)) {
        New-Item -ItemType Directory -Path $Parent | Out-Null
    }
}

function Set-RoutingBlock($File, $Title) {
    Ensure-ParentDir $File

    if ((Test-Path -LiteralPath $File -PathType Leaf) -and ((Get-Content -LiteralPath $File -Raw) -match [regex]::Escape($MarkerBegin))) {
        $Content = Get-Content -LiteralPath $File -Raw
        $Pattern = "(?s)" + [regex]::Escape($MarkerBegin) + ".*?" + [regex]::Escape($MarkerEnd)
        $Updated = [regex]::Replace($Content, $Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $RoutingBlock })
        Set-Content -LiteralPath $File -Value $Updated -NoNewline
        Write-Info "Updated ${Title}: $File"
    }
    else {
        if ((Test-Path -LiteralPath $File -PathType Leaf) -and ((Get-Item -LiteralPath $File).Length -gt 0)) {
            Add-Content -LiteralPath $File -Value "`n$RoutingBlock"
        }
        else {
            Set-Content -LiteralPath $File -Value $RoutingBlock -NoNewline
        }
        Write-Info "Installed ${Title}: $File"
    }
}

function Install-Skills {
    if (-not (Test-Path -LiteralPath $DestSkillsDir -PathType Container)) {
        New-Item -ItemType Directory -Path $DestSkillsDir | Out-Null
    }

    Get-ChildItem -LiteralPath $SourceSkillsDir -Directory | ForEach-Object {
        $SkillName = $_.Name
        $Dest = Join-Path $DestSkillsDir $SkillName

        if ((Test-Path -LiteralPath $Dest) -and (-not $Force)) {
            Fail "skill already exists: $Dest. Re-run with -Force to replace installed skills."
        }

        if (Test-Path -LiteralPath $Dest) {
            Remove-Item -LiteralPath $Dest -Recurse -Force
        }

        Copy-Item -LiteralPath $_.FullName -Destination $Dest -Recurse
    }

    if (Test-Path -LiteralPath $SourceRegistryFile -PathType Leaf) {
        $RegistryDest = Join-Path (Split-Path -Parent $DestSkillsDir) "registry.json"
        Copy-Item -LiteralPath $SourceRegistryFile -Destination $RegistryDest
        Write-Info "Installed registry: $RegistryDest"
    }

    Write-Info "Installed skills: $DestSkillsDir"
}

Install-Skills

if ($Claude) {
    Set-RoutingBlock (Join-Path $TargetProject "CLAUDE.md") "Claude instructions"
}

if ($OpenCode) {
    Set-RoutingBlock (Join-Path $TargetProject "AGENTS.md") "OpenCode instructions"
}

if ($Copilot) {
    Set-RoutingBlock (Join-Path $TargetProject ".github/copilot-instructions.md") "GitHub Copilot instructions"
}

Write-Info "Done. Installed Agentic Dev System at project level."
