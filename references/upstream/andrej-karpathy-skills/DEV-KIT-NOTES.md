# Dev-Kit Utilization Notes

## Source Summary

This reference contributes one compact behavior skill, `karpathy-guidelines`, plus matching `CLAUDE.md` guidance.

Core principles:

- Think before coding: surface assumptions, tradeoffs, and confusion before implementation.
- Simplicity first: solve only the requested problem with minimum code and no speculative abstractions.
- Surgical changes: touch only lines that trace to the request, and clean up only unused code introduced by the change.
- Goal-driven execution: turn requests into verifiable success criteria and loop until evidence exists.

## Fit With Current Dev-Kit

The reference is not a separate lifecycle workflow. It is a behavioral quality layer that reinforces existing dev-kit skills.

Best integration points:

- `start-work`: strengthen ambiguity handling by explicitly naming assumptions and simpler alternatives before choosing a workflow.
- `shape-work`: use the multiple-interpretations pattern when a request has product or technical ambiguity.
- `plan-work`: ensure every task has success criteria and a verification check, not just implementation steps.
- `execute-work`: add a surgical-diff gate that every changed line must trace to the task.
- `tdd-work`: reinforce the transformation from imperative fixes to failing tests and verifiable goals.
- `simplify-work`: borrow the senior-engineer overcomplication test and the no-single-use-abstractions rule.
- `review-work`: check for assumption leaks, speculative features, unnecessary abstraction, and unrelated edits.
- `auto-dev-loop`: preserve autonomy while stopping for real ambiguity instead of silently choosing an interpretation.

## Recommended Changes

Do not install `karpathy-guidelines` as a standalone default skill yet. The current dev-kit already routes by work type, and a generic behavioral skill could compete with more specific workflows.

Instead, fold these principles into existing skills as small hard rules or review checks:

1. Add an assumption/tradeoff check to `start-work` and `shape-work`.
2. Add a surgical-change check to `execute-work` and `review-work`.
3. Add a no-speculative-abstraction rule to `simplify-work` if it needs stronger wording.
4. Add a success-criteria phrasing check to `plan-work` and `auto-dev-loop`.

## Implementation Decision

The integration is implemented as embedded gates in existing dev-kit skills, not as a standalone installed `karpathy-guidelines` skill.

Updated skills:

- `start-work`
- `shape-work`
- `plan-work`
- `auto-dev-loop`
- `execute-work`
- `review-work`
- `simplify-work`
- `tdd-work`

This preserves work-type routing while adding checks for assumptions, multiple interpretations, success criteria, surgical diffs, overcomplication, and failing signals.

## Guardrails

- Keep the dev-kit offline-installable; do not adopt the upstream `curl` or plugin-install instructions into project installers.
- Keep source attribution in this reference snapshot rather than copying marketing or install content into runtime skills.
- Treat examples as review heuristics, not as project-specific implementation templates.
