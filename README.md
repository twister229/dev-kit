# Agentic Dev System Skills

First-version combined skillset based on `obra/superpowers` and `codeaholicguy/ai-devkit`.

The point is not to collect every possible workflow. The point is to make an agent behave like a careful developer: scope the work, plan only when useful, execute with clean context, verify with fresh evidence, and store lessons that will save time later.

## Skills

| Skill | Use When | Combines |
|---|---|---|
| `start-work` | Starting a feature, unclear request, or multi-step task | Superpowers brainstorming/worktrees + AI DevKit lifecycle |
| `plan-work` | Requirements exist and implementation needs sequencing | Superpowers writing-plans + AI DevKit requirements/design review |
| `execute-work` | A written plan is ready to implement | Superpowers subagent-driven-development + AI DevKit agent orchestration |
| `debug-root-cause` | Bug, regression, failing test, unexpected behavior | Superpowers systematic-debugging + AI DevKit debug/memory |
| `verify-work` | About to claim something is done, fixed, passing, or ready | Superpowers verification-before-completion + AI DevKit verify |
| `simplify-work` | Refactor, reduce complexity, clean up, improve maintainability | AI DevKit simplify-implementation + Superpowers YAGNI/TDD discipline |
| `capture-learning` | Document code, store reusable knowledge, preserve decisions | AI DevKit memory/capture-knowledge + branch finish learnings |
| `finish-work` | Branch is ready for final review, commit, or PR | Superpowers finish branch + code review workflows |
| `writing-skills` | Creating or improving skills | Superpowers writing-skills retained as a first-class skill |

## Routing

Add this to an agent instruction file such as `AGENTS.md`:

```markdown
## Skill Routing

- New feature, vague product request, multi-step build -> `start-work`
- Requirements or design already exist -> `plan-work`
- Written implementation plan ready -> `execute-work`
- Bug, failing test, regression, production issue -> `debug-root-cause`
- Any done/fixed/passing/ready claim -> `verify-work`
- Refactor, simplify, reduce complexity -> `simplify-work`
- Understand, document, or remember code/project knowledge -> `capture-learning`
- Branch ready for final review, commit, or PR -> `finish-work`
- Create or revise skills -> `writing-skills`
```

## Golden Path

```text
start-work -> plan-work -> execute-work -> verify-work -> capture-learning -> finish-work
```

## Fast Path

For tiny low-risk tasks, do not create lifecycle docs. Make the change, run `verify-work`, and report the evidence.

## Core Rules

- Default to speed. Escalate to rigor when risk appears.
- No fixes without root cause for bugs.
- No completion claims without fresh command output.
- Use fresh implementation context for non-trivial tasks.
- Spec compliance review comes before code quality review.
- Store only reusable, verified knowledge. Do not store transcripts, secrets, or one-off progress.
- Some duplication beats the wrong abstraction.
