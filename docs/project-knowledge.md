# Project Knowledge

`project-knowledge` adds an offline, Markdown-first knowledge layer for projects that install dev-kit.

The goal is to give future agent sessions shared context before they run `plan-work`, `execute-work`, `review-work`, `debug-root-cause`, or `orchestrate-agents`.

## Why This Exists

Large repos need more than task memory. Agents repeatedly rediscover:

- entry points;
- module boundaries;
- important runtime/data flows;
- project conventions;
- verified failure patterns;
- decisions that explain why code looks the way it does.

Inspired by codebase-understanding and knowledge-graph tools, dev-kit keeps the implementation simple and portable: Markdown files in the target repo, with evidence attached to every claim.

## Default Layout In Target Projects

```text
docs/ai/knowledge/
  index.md
  architecture.md
  flows.md
  decisions.md
  conventions.md
  failure-patterns.md
  modules/
    <module-name>.md
```

## Recommended Flow

```text
codebase-map map the billing subsystem before refactoring it
project-knowledge promote that map into docs/ai/knowledge/modules/billing.md
plan-work create the implementation plan using project knowledge as context
execute-work implement task 1
review-work review the diff against the plan and project knowledge
verify-work prove the change is safe
project-knowledge update the affected module knowledge if the architecture changed
```

## Rules

- Store verified reusable knowledge only.
- Cite evidence: source files, symbols, tests, command output, or explicit user instruction.
- Mark unknown/stale areas instead of guessing.
- Never store secrets, raw logs, transcripts, customer data, or one-off progress.
- Use `context-handoff` for paused task state.
- Use `capture-learning` for narrow reusable lessons; promote to `project-knowledge` when it should support future workflows broadly.
