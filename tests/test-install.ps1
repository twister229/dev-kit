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
    Assert-File (Join-Path $Project ".agentic-dev-system/skills/start-work/SKILL.md")
    Assert-File (Join-Path $Project ".agentic-dev-system/skills/tdd-work/SKILL.md")
    Assert-File (Join-Path $Project ".agentic-dev-system/skills/review-feedback/SKILL.md")
    Assert-File (Join-Path $Project ".agentic-dev-system/skills/docs-review/SKILL.md")
    Assert-File (Join-Path $Project ".agentic-dev-system/registry.json")
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
    Assert-File (Join-Path $Selective ".agentic-dev-system/registry.json")

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
