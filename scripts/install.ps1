param(
    [string]$TargetProject = ".",
    [switch]$All,
    [switch]$Claude,
    [switch]$OpenCode,
    [switch]$Copilot,
    [string]$SkillsDir = "",
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
  -All              Install Claude, OpenCode, and GitHub Copilot targets (default)
  -Claude           Install Claude skills to .claude/skills and CLAUDE.md
  -OpenCode         Install OpenCode skills to .opencode/skills and AGENTS.md
  -Copilot          Install GitHub Copilot prompts to .github/prompts and instructions
  -SkillsDir DIR    Advanced: install all selected skill folders to one custom project-relative directory
  -Force            Replace existing installed skill files
  -Help             Show help

Examples:
  ./scripts/install.ps1 -TargetProject C:\path\to\project
  ./scripts/install.ps1 -TargetProject . -Claude -OpenCode
  ./scripts/install.ps1 -TargetProject C:\app -Force
  ./scripts/install.ps1 -TargetProject C:\app -SkillsDir .custom/skills -Force

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

if ($SkillsDir -and [System.IO.Path]::IsPathRooted($SkillsDir)) {
    Fail "-SkillsDir must be project-relative, got: $SkillsDir"
}

$SkillParts = $SkillsDir -split '[\\/]+'
if ($SkillsDir -and $SkillParts -contains "..") {
    Fail "-SkillsDir must not contain '..', got: $SkillsDir"
}

if (-not (Test-Path -LiteralPath $TargetProject -PathType Container)) {
    Fail "target project does not exist: $TargetProject"
}

$TargetProject = (Resolve-Path $TargetProject).Path

$MarkerBegin = "<!-- agentic-dev-system:begin -->"
$MarkerEnd = "<!-- agentic-dev-system:end -->"

$RoutingBlock = @"
$MarkerBegin
## Agentic Dev System Skills

Provider-native files are installed for the selected tools:

- Claude: ``.claude/skills``
- OpenCode: ``.opencode/skills``
- GitHub Copilot: ``.github/prompts``

When the user's request matches one of these workflows, use the matching skill before answering directly:

- New feature, vague product request, multi-step build -> ``start-work``
- Vague product or technical direction needs shaping -> ``shape-work``
- Requirements or design already exist -> ``plan-work``
- Written implementation plan ready -> ``execute-work``
- Autonomous end-to-end lifecycle until verified complete or blocked -> ``auto-dev-loop``
- Isolated git worktree or branch context needed -> ``worktree-work``
- Multiple agents or parallel workstreams need coordination -> ``orchestrate-agents``
- New behavior, bug fix, or behavior refactor -> ``tdd-work``
- Bug, failing test, regression, production issue -> ``debug-root-cause``
- Any done/fixed/passing/ready claim -> ``verify-work``
- Refactor, simplify, reduce complexity -> ``simplify-work``
- Understand, document, or remember code/project knowledge -> ``capture-learning``
- Received code review feedback -> ``review-feedback``
- Review README, install docs, guides, or skill docs -> ``docs-review``
- Code review, diff review, implementation check -> ``review-work``
- Branch ready for final review, commit, or PR -> ``finish-work``
- Create or revise skills -> ``writing-skills``

Golden path: ``start-work -> shape-work when needed -> plan-work -> execute-work -> review-work -> verify-work -> capture-learning -> finish-work``.

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

function Install-Skills($DestSkillsDir) {
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

function Install-CustomSkills {
    $DestSkillsDir = Join-Path $TargetProject $SkillsDir
    Install-Skills $DestSkillsDir
}

function Install-CopilotPrompts {
    $PromptsDir = Join-Path $TargetProject ".github/prompts"
    if (-not (Test-Path -LiteralPath $PromptsDir -PathType Container)) {
        New-Item -ItemType Directory -Path $PromptsDir | Out-Null
    }

    Get-ChildItem -LiteralPath $SourceSkillsDir -Directory | ForEach-Object {
        $SkillName = $_.Name
        $PromptFile = Join-Path $PromptsDir "$SkillName.prompt.md"

        if ((Test-Path -LiteralPath $PromptFile) -and (-not $Force)) {
            Fail "prompt already exists: $PromptFile. Re-run with -Force to replace installed prompts."
        }

        $SkillContent = Get-Content -LiteralPath (Join-Path $_.FullName "SKILL.md") -Raw
        $PromptContent = "# $SkillName`n`nUse this workflow when the user request matches this prompt. Source skill: ``$SkillName``.`n`n$SkillContent"
        Set-Content -LiteralPath $PromptFile -Value $PromptContent -NoNewline
    }

    if (Test-Path -LiteralPath $SourceRegistryFile -PathType Leaf) {
        $RegistryDest = Join-Path $TargetProject ".github/dev-kit-registry.json"
        Copy-Item -LiteralPath $SourceRegistryFile -Destination $RegistryDest
        Write-Info "Installed registry: $RegistryDest"
    }

    Write-Info "Installed Copilot prompts: $PromptsDir"
}

if ($SkillsDir) {
    Install-CustomSkills
}

if ($Claude) {
    if (-not $SkillsDir) {
        Install-Skills (Join-Path $TargetProject ".claude/skills")
    }
    Set-RoutingBlock (Join-Path $TargetProject "CLAUDE.md") "Claude instructions"
}

if ($OpenCode) {
    if (-not $SkillsDir) {
        Install-Skills (Join-Path $TargetProject ".opencode/skills")
    }
    Set-RoutingBlock (Join-Path $TargetProject "AGENTS.md") "OpenCode instructions"
}

if ($Copilot) {
    if (-not $SkillsDir) {
        Install-CopilotPrompts
    }
    Set-RoutingBlock (Join-Path $TargetProject ".github/copilot-instructions.md") "GitHub Copilot instructions"
}

Write-Info "Done. Installed Agentic Dev System at project level."
