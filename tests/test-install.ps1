Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("dev-kit-test-" + [System.Guid]::NewGuid().ToString())

function Fail($Message) {
    Write-Error "FAIL: $Message"
    exit 1
}

function Assert-File($Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Fail "expected file: $Path"
    }
}

function Assert-NotFile($Path) {
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Fail "unexpected file: $Path"
    }
}

function Assert-MarkerOnce($Path) {
    $Content = Get-Content -LiteralPath $Path -Raw
    $Matches = [regex]::Matches($Content, [regex]::Escape("<!-- agentic-dev-system:begin -->"))
    if ($Matches.Count -ne 1) {
        Fail "expected one routing marker in $Path, got $($Matches.Count)"
    }
}

try {
    New-Item -ItemType Directory -Path $Tmp | Out-Null
    $Project = Join-Path $Tmp "project"
    New-Item -ItemType Directory -Path $Project | Out-Null

    & (Join-Path $Root "scripts/install.ps1") -TargetProject $Project

    Assert-File (Join-Path $Project "CLAUDE.md")
    Assert-File (Join-Path $Project "AGENTS.md")
    Assert-File (Join-Path $Project ".github/copilot-instructions.md")
    Assert-File (Join-Path $Project ".claude/skills/start-work/SKILL.md")
    Assert-File (Join-Path $Project ".claude/skills/tdd-work/SKILL.md")
    Assert-File (Join-Path $Project ".claude/registry.json")
    Assert-File (Join-Path $Project ".opencode/skills/review-feedback/SKILL.md")
    Assert-File (Join-Path $Project ".opencode/skills/docs-review/SKILL.md")
    Assert-File (Join-Path $Project ".opencode/registry.json")
    Assert-File (Join-Path $Project ".github/prompts/start-work.prompt.md")
    Assert-File (Join-Path $Project ".github/prompts/docs-review.prompt.md")
    Assert-File (Join-Path $Project ".github/dev-kit-registry.json")
    Assert-MarkerOnce (Join-Path $Project "CLAUDE.md")
    Assert-MarkerOnce (Join-Path $Project "AGENTS.md")
    Assert-MarkerOnce (Join-Path $Project ".github/copilot-instructions.md")

    & (Join-Path $Root "scripts/install.ps1") -TargetProject $Project -Force
    Assert-MarkerOnce (Join-Path $Project "CLAUDE.md")
    Assert-MarkerOnce (Join-Path $Project "AGENTS.md")
    Assert-MarkerOnce (Join-Path $Project ".github/copilot-instructions.md")

    $Selective = Join-Path $Tmp "selective"
    New-Item -ItemType Directory -Path $Selective | Out-Null
    & (Join-Path $Root "scripts/install.ps1") -TargetProject $Selective -Claude
    Assert-File (Join-Path $Selective "CLAUDE.md")
    Assert-NotFile (Join-Path $Selective "AGENTS.md")
    Assert-NotFile (Join-Path $Selective ".github/copilot-instructions.md")
    Assert-File (Join-Path $Selective ".claude/skills/start-work/SKILL.md")
    Assert-File (Join-Path $Selective ".claude/registry.json")
    Assert-NotFile (Join-Path $Selective ".opencode/registry.json")
    Assert-NotFile (Join-Path $Selective ".github/dev-kit-registry.json")

    $Custom = Join-Path $Tmp "custom"
    New-Item -ItemType Directory -Path $Custom | Out-Null
    & (Join-Path $Root "scripts/install.ps1") -TargetProject $Custom -Claude -SkillsDir ".custom/skills"
    Assert-File (Join-Path $Custom "CLAUDE.md")
    Assert-File (Join-Path $Custom ".custom/skills/start-work/SKILL.md")
    Assert-File (Join-Path $Custom ".custom/registry.json")
    Assert-NotFile (Join-Path $Custom ".claude/skills/start-work/SKILL.md")

    $BadRel = Join-Path $Tmp "bad-rel"
    New-Item -ItemType Directory -Path $BadRel | Out-Null
    $Failed = $false
    try {
        & (Join-Path $Root "scripts/install.ps1") -TargetProject $BadRel -SkillsDir "../bad" *> $null
    }
    catch {
        $Failed = $true
    }
    if (-not $Failed) {
        Fail "parent traversal -SkillsDir should fail"
    }

    Write-Output "PASS: install.ps1 offline installer"
}
finally {
    if (Test-Path -LiteralPath $Tmp) {
        Remove-Item -LiteralPath $Tmp -Recurse -Force
    }
}
