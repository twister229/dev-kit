---
name: seed-data-work
description: Use when creating, updating, or verifying local development seed data, test fixtures, sample SQL inserts, or backend data setup for any database-backed project. Do not use for production data changes.
---

# Seed Data Work

## Purpose

Generate safe, realistic, idempotent seed or test data that supports a requested local development scenario and proves target API/UI paths work without touching production data or using real personal/customer information.

## When To Use

- A local dev or test scenario needs database rows, fixtures, or migration-backed sample data.
- Any database-backed project needs entity/table/document dependency ordering across SQL, ORM, migration, fixture, or NoSQL-style data models.
- Tests, demos, API flows, or UI paths need representative data.
- Existing seed files need review for safety, idempotency, reversibility, or domain correctness.

## When Not To Use

- Production, staging, shared customer, analytics, or live support database changes.
- Data repair, backfills, or destructive migrations for real environments.
- Synthetic data that must satisfy legal, privacy, statistical, or ML quality requirements.
- Ordinary feature work where no database setup or fixture data is needed.
- Tasks requiring secrets, real accounts, real emails, payment details, tokens, or customer records.

## Hard Rules

- Confirm the target is local dev/test before any write or load command. Stop if the environment may be prod, staging, shared, or unclear.
- Never use real personal data, customer data, credentials, tokens, payment data, or production identifiers.
- Do not run destructive SQL, truncate tables, reset schemas, or overwrite fixtures without explicit confirmation.
- Prefer idempotent and reversible seeds: `INSERT ... ON CONFLICT`, `MERGE`, upsert helpers, stable synthetic IDs, transactions, rollback notes, or down/cleanup scripts.
- Respect existing project conventions for migrations, fixtures, factories, containers, profiles, and test data builders.
- Derive dependency order from evidence, not guesses. Use schema/migration/ORM/test/DB introspection sources when available.
- Keep generated data minimal for the scenario; avoid broad fixture dumps.
- Verify by loading into a local dev/test DB and exercising the requested API/UI/test path before claiming success.
- If environment safety or dependency order is unresolved, report `BLOCKED` instead of guessing.

## Workflow

1. Define the scenario and safety boundary.
   - Identify the API/UI/test path that must work.
   - Identify the local profile, database, schema, tenant, and seed mechanism.
   - Stop if the target is not clearly local dev/test.
2. Discover existing data conventions.
   - Look for migrations: Flyway/Liquibase, SQL DDL, schema dumps.
   - Look for data models and ORM mappings: JPA/Hibernate, Rails ActiveRecord, Django models, Prisma schema, Sequelize/TypeORM, SQLAlchemy, Ecto, Entity Framework, Mongoose, XML/YAML mappings, or project-specific repositories.
   - Look for fixtures/factories/builders: tests, seed scripts, demo data, Testcontainers setup.
   - If safe and available, introspect the local DB schema for tables, columns, constraints, indexes, and foreign keys.
3. Select required tables/entities from the scenario.
   - Trace from the target endpoint/page/job to services, repositories, entities, DTOs, and validation.
   - Include authentication, tenant, organization, lookup, enum, status, join, audit, and ownership rows only when needed.
   - Mark optional data separately from required dependencies.
4. Determine dependency order.
   - Build parent-before-child order from foreign keys, join tables, non-null columns, unique constraints, and natural keys.
   - Cross-check migrations/DDL against ORM annotations such as `@ManyToOne`, `@OneToMany`, `@JoinColumn`, `@Enumerated`, validation annotations, and cascade rules.
   - Reuse existing fixture IDs or reference data when the project already provides them.
   - Document any assumptions or unresolved relationships.
5. Choose safe sample values.
   - Use constraints, enums, validation annotations, domain examples, tests, API docs, UI forms, and existing fixtures.
   - Use obviously synthetic names, emails, phone numbers, addresses, and IDs, e.g. `dev-user@example.test`.
   - Avoid secrets; use placeholders only when the app accepts them locally.
   - Satisfy uniqueness, length, format, timezone, status lifecycle, and tenant/authorization rules.
6. Generate data in the project-native form.
   - Prefer existing fixture/factory/migration style.
   - For SQL, use explicit columns, stable keys, `ON CONFLICT`/`MERGE`/guarded inserts where supported, and wrap multi-table loads in a transaction.
   - Include rollback/down/cleanup guidance when the project mechanism supports it.
   - Avoid disabling constraints unless the project already does so safely for local fixtures.
7. Load and verify locally.
   - Run the project’s local migration/seed/test command against the dev/test DB.
   - Exercise the target API/UI path or focused test that motivated the seed data.
   - Inspect errors for constraint, enum, validation, auth, tenant, or lifecycle mismatches and iterate from evidence.
8. Report exactly what changed and how to rerun or clean up.

## Output Template

```markdown
## Seed Data Work

Scenario: ...
Safety boundary: local dev/test target verified | BLOCKED because ...
Required data graph: table/entity order with why each row is needed
Sample value sources: constraints/enums/tests/UI/API/domain examples used
Files or commands changed: ...
Load command: command, exit code, key output
Verification: API/UI/test command or path, exit code/result, key output
Rollback/cleanup: ...
Status: DONE | BLOCKED | NEEDS_DECISION
```

## Evaluation Notes

- Trigger test: "Create seed data so the local app can show an order with two line items in the admin UI" should invoke `seed-data-work`.
- Negative trigger test: "Backfill missing order statuses in production" must not invoke this skill as an execution workflow; it should stop for production-data safety.
- Workflow test: A fresh agent identifies migrations/entities/tests, orders parent rows before child rows, and generates idempotent local-only seed data.
- Failure-mode test: If the DB URL or profile is ambiguous, the agent reports `BLOCKED` before loading data.
- Output test: The final report includes safety boundary, dependency graph, value sources, load evidence, verification evidence, and rollback/cleanup.

Scores target 4+/5 for trigger specificity, behavioral clarity, failure-mode coverage, verification gates, output usefulness, and length discipline.

## Red Flags

| Rationalization | Why It Is Wrong | Do Instead |
|---|---|---|
| "It is just seed data, so prod is fine" | Seed scripts can corrupt or expose live data | Confirm local dev/test or stop |
| "Fake-looking real customer data is okay" | Real data creates privacy and compliance risk | Use synthetic `.test` values and invented records |
| "Disable constraints and insert children first" | Masks wrong dependency understanding | Derive parent-child order from schema evidence |
| "A big dump will cover every scenario" | Bloated fixtures are brittle and hard to clean | Generate minimal scenario-specific rows |
| "If SQL runs, verification is done" | Data may not satisfy API/UI/auth/domain flows | Exercise the target path or focused test |
