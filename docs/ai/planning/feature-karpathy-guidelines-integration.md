# Karpathy Guidelines Integration Plan

Goal: Fold the `andrej-karpathy-skills` reference into dev-kit as targeted behavior gates inside existing lifecycle skills.
User outcome: Agents using dev-kit make fewer silent assumptions, produce smaller diffs, avoid speculative abstractions, and define verifiable goals without adding a competing generic workflow.
Architecture: Keep routing by work type. Do not install `karpathy-guidelines` as a standalone default skill. Add short hard rules, workflow checks, and review criteria to the existing skills that already own each lifecycle phase.
Risk: Small
Execution: Use `execute-work` for task-by-task implementation, or direct edits if the user chooses to keep this as one small docs-only change. Use `writing-skills` as the quality standard for each skill edit.
Verification: Use `verify-work` before any completion claim.

## Context

Reference source:

- `references/upstream/andrej-karpathy-skills/CLAUDE.md`
- `references/upstream/andrej-karpathy-skills/skills/karpathy-guidelines/SKILL.md`
- `references/upstream/andrej-karpathy-skills/DEV-KIT-NOTES.md`

The useful source principles are:

- Think before coding: surface assumptions, ambiguity, tradeoffs, and simpler alternatives.
- Simplicity first: solve only the requested problem with no speculative features or abstractions.
- Surgical changes: every changed line should trace to the request or task.
- Goal-driven execution: convert work into success criteria and verification evidence.

## Task 1: Strengthen Ambiguity Handling In `start-work` And `shape-work`

Files:
- Modify: `skills/start-work/SKILL.md`
- Modify: `skills/shape-work/SKILL.md`

Acceptance:
- [ ] `start-work` requires meaningful assumptions, ambiguity, and simpler alternatives to be surfaced before routing or implementation.
- [ ] `shape-work` requires multiple plausible interpretations to be listed as options instead of silently choosing one.
- [ ] Both skills preserve the existing rule to avoid excessive questions and use safe, explicit, reversible assumptions when appropriate.
- [ ] The edits are concise and do not copy the upstream reference verbatim.

Steps:
- [ ] In `skills/start-work/SKILL.md`, add a hard rule: if the request has meaningful ambiguity, name assumptions and simpler alternatives before choosing the next workflow.
- [ ] In `skills/start-work/SKILL.md`, add a workflow bullet under classification or context inspection to record assumptions/tradeoffs in the start brief.
- [ ] In `skills/shape-work/SKILL.md`, add a hard rule: do not pick silently when multiple interpretations are plausible.
- [ ] In `skills/shape-work/SKILL.md`, add workflow guidance to present 2-3 interpretations as options when ambiguity is real.
- [ ] Run verification.

Command: `grep -n "assumption\|interpretation\|simpler alternative" skills/start-work/SKILL.md skills/shape-work/SKILL.md`
Expected: exits 0 and prints matching lines from both skills.

## Task 2: Add Goal-Driven Planning Checks

Files:
- Modify: `skills/plan-work/SKILL.md`
- Modify: `skills/auto-dev-loop/SKILL.md`

Acceptance:
- [ ] `plan-work` requires each task to state success criteria and the verification signal proving them.
- [ ] `auto-dev-loop` reinforces that weak goals like "make it work" must become verifiable outcomes before autonomous looping.
- [ ] `auto-dev-loop` stops for meaningful ambiguity instead of silently picking an interpretation.
- [ ] The edits preserve existing offline/local verification rules.

Steps:
- [ ] In `skills/plan-work/SKILL.md`, add a hard rule or workflow check requiring success criteria plus verification signal for every task.
- [ ] In the `plan-work` task template, ensure acceptance and verification language remains concrete enough for a fresh agent.
- [ ] In `skills/auto-dev-loop/SKILL.md`, add a hard rule that autonomy does not permit silent choice on meaningful ambiguity.
- [ ] In `skills/auto-dev-loop/SKILL.md`, add a workflow bullet to convert weak goals into verifiable outcomes before implementation cycles.
- [ ] Run verification.

Command: `grep -n "success criteria\|verifiable\|meaningful ambiguity" skills/plan-work/SKILL.md skills/auto-dev-loop/SKILL.md`
Expected: exits 0 and prints matching lines from both skills.

## Task 3: Add Surgical-Diff Gates To Execution And Review

Files:
- Modify: `skills/execute-work/SKILL.md`
- Modify: `skills/review-work/SKILL.md`

Acceptance:
- [ ] `execute-work` requires each task diff to be checked so changed lines trace to the task, verification, or cleanup caused by the task.
- [ ] `review-work` checks for unrelated edits, speculative features, assumption leaks, and unnecessary abstractions.
- [ ] `review-work` keeps findings-first output and spec-before-quality ordering.
- [ ] No new standalone workflow is introduced.

Steps:
- [ ] In `skills/execute-work/SKILL.md`, add a hard rule or per-task review bullet: every changed line must trace to the task, its verification, or cleanup introduced by the task.
- [ ] In `skills/review-work/SKILL.md`, add hard rules or review checks for unrelated edits, speculative features, hidden assumptions, and unnecessary abstractions.
- [ ] Add a red flag to `review-work` for "while I was here" edits if not already covered.
- [ ] Run verification.

Command: `grep -n "changed line\|speculative\|unrelated edits\|assumption" skills/execute-work/SKILL.md skills/review-work/SKILL.md`
Expected: exits 0 and prints matching lines from both skills.

## Task 4: Strengthen Simplicity And TDD Behavior

Files:
- Modify: `skills/simplify-work/SKILL.md`
- Modify: `skills/tdd-work/SKILL.md`

Acceptance:
- [ ] `simplify-work` includes the senior-engineer overcomplication test.
- [ ] `simplify-work` keeps or strengthens the no speculative abstraction rule.
- [ ] `tdd-work` reinforces transforming requested fixes or behavior into a failing test or reproducible signal before production code.
- [ ] The edits do not weaken existing TDD iron law or offline verification rules.

Steps:
- [ ] In `skills/simplify-work/SKILL.md`, add a hard rule or workflow bullet: ask whether a senior engineer would call the result overcomplicated; if yes, simplify.
- [ ] In `skills/simplify-work/SKILL.md`, ensure no-single-use/no-hypothetical-abstraction language remains explicit.
- [ ] In `skills/tdd-work/SKILL.md`, add a workflow or hard-rule line that converts imperative requests into a behavior statement and failing signal first.
- [ ] Run verification.

Command: `grep -n "senior engineer\|overcomplicated\|failing signal\|behavior statement" skills/simplify-work/SKILL.md skills/tdd-work/SKILL.md`
Expected: exits 0 and prints matching lines from both skills.

## Task 5: Update Reference Notes With Implementation Decision

Files:
- Modify: `references/upstream/andrej-karpathy-skills/DEV-KIT-NOTES.md`

Acceptance:
- [ ] Notes state that the integration was implemented as embedded skill gates, not a standalone installed skill.
- [ ] Notes list the exact dev-kit skills updated.
- [ ] Notes preserve guardrails against adopting upstream network install instructions.

Steps:
- [ ] Add an `## Implementation Decision` section to `references/upstream/andrej-karpathy-skills/DEV-KIT-NOTES.md` after `## Recommended Changes`.
- [ ] Name the updated skills: `start-work`, `shape-work`, `plan-work`, `auto-dev-loop`, `execute-work`, `review-work`, `simplify-work`, and `tdd-work`.
- [ ] Run verification.

Command: `grep -n "Implementation Decision\|start-work\|tdd-work" references/upstream/andrej-karpathy-skills/DEV-KIT-NOTES.md`
Expected: exits 0 and prints the implementation decision heading and updated skill references.

## Final Acceptance Checklist

- [ ] No standalone `skills/karpathy-guidelines/` directory is added.
- [ ] Existing skill routing remains work-type based.
- [ ] `references/upstream/andrej-karpathy-skills/` remains reference-only.
- [ ] `./tests/test-skill-structure.sh` passes.
- [ ] `./tests/test-upstream-references.sh` passes.
- [ ] `git diff` shows only skill-doc and reference-note changes plus this plan.

## Final Verification Commands

```bash
./tests/test-skill-structure.sh
./tests/test-upstream-references.sh
test ! -d skills/karpathy-guidelines
```

Expected: all commands exit 0.
