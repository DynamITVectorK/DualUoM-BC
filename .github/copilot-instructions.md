# GitHub Copilot Instructions — DualUoM-BC

## Project Summary

This repository contains **DualUoM**, a Per-Tenant Extension (PTE) for Microsoft Dynamics 365 Business Central SaaS. The extension implements a dual unit-of-measure model for items, allowing quantities to be tracked simultaneously in two independent units (e.g. pieces and kilograms).

## Development Philosophy

### Issue-focused increments

- **Work only on the assigned issue.** Each pull request must address exactly one GitHub Issue.
- Do not implement functionality that is described in other issues, even if it seems related or convenient.
- If you discover that completing the current issue requires a change that belongs to a different issue, stop and flag this in a PR comment rather than implementing it silently.

### Test-Driven Development (TDD)

- **Write the test before writing production code.** Every new feature or behaviour must be covered by an AL test codeunit before implementation begins.
- **Compilation alone is not enough.** A feature is not complete unless its AL tests pass in the AL-Go CI pipeline.
- Tests must cover the happy path and key error/edge-case paths defined in the issue acceptance criteria.
- Do not merge code that causes existing tests to fail.

### Scope discipline

- Do not add posting logic unless the issue explicitly requires it.
- Do not add warehouse management logic unless the issue explicitly requires it.
- Do not create setup tables or pages unless the issue explicitly requires it.
- Do not implement DUOM business functionality in issues that are marked as documentation or foundation only.

## AL Coding Standards

Refer to `/.github/instructions/al.instructions.md` for detailed AL language rules and conventions.

## Repository Structure

```
/
├── docs/
│   ├── 01-product/          # Product requirements
│   ├── 02-functional/       # Functional design
│   ├── 03-architecture/     # Architecture and data model
│   ├── 06-testing/          # Test plan and TDD guidelines
│   └── 07-backlog/          # Epics and issue breakdown
├── .github/
│   ├── copilot-instructions.md   # This file
│   ├── instructions/
│   │   └── al.instructions.md    # AL-specific coding rules
│   └── workflows/               # AL-Go CI/CD workflows
└── (AL app folders will be added per Epic)
```

## Definition of Done

A pull request is ready to merge when:

- [ ] All acceptance criteria from the linked issue are met.
- [ ] AL tests covering the new functionality are included and pass.
- [ ] All pre-existing tests continue to pass.
- [ ] Code follows the AL conventions in `al.instructions.md`.
- [ ] The PR scope is limited to the assigned issue — no unrelated changes.
- [ ] A human reviewer has approved the PR.
