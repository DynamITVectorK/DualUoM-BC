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

### No hardcode

**Never** hardcode values in AL code. Examples of prohibited hardcode:

- Unit of measure codes (`'KG'`, `'PCS'`, `'UN'`, etc.)
- Numeric conversion factors
- Serial numbers, prefixes, or ranges
- Literal error texts outside a `Label` variable
- Record IDs

#### How to resolve existing hardcode

1. **Labels** — use `Label` variables (with `Locked = true`) for all string constants, including error messages and display texts.
2. **Setup tables** — use setup tables for user-configurable values that vary by company or deployment.
3. **Parameters** — pass context-specific values as procedure parameters rather than reading global state.
4. If a hardcoded value is found in the current code, investigate whether an appropriate setup table exists and migrate the value there.

> **In test code**, use `Label` variables with `Locked = true` to define string constants used in test fixtures (e.g., test UoM codes). This avoids literal string duplication across test methods and keeps test code consistent with the same convention.

```al
// CORRECT — Label constant for a test fixture value
var
    KGUoMCodeTok: Label 'KG', Locked = true;

// INCORRECT — bare string literal scattered across test methods
Item."DUOM Secondary UoM Code" := 'KG';
```

## AL Test Conventions

The following conventions and known pitfalls **must** be followed in every test codeunit. They were discovered during DualUoM development and prevent recurring CI failures.

### Correct Assert declaration

Always declare the assert helper as `LibraryAssert` using the quoted `"Library Assert"` codeunit. Using the unquoted `Assert` codeunit causes compiler error **AL0185**.

```al
// CORRECT
var
    LibraryAssert: Codeunit "Library Assert";

// INCORRECT — causes AL0185
var
    Assert: Codeunit Assert;
```

All assertion calls must use `LibraryAssert.AreEqual(...)`, `LibraryAssert.IsTrue(...)`, `LibraryAssert.IsFalse(...)`, etc.

### Test app dependencies in app.json

The test app must declare `Library Assert` with a **fixed version number**. Do **not** use `$(app_minimumVersion)` — this causes download errors in the AL-Go pipeline.

```json
{
    "id": "dd0be2ea-f733-4d65-bb34-a28f4624fb14",
    "name": "Library Assert",
    "publisher": "Microsoft",
    "version": "27.0.0.0"
}
```

Do **not** add `Tests-TestLibraries` or `System Application Test Library` as dependencies unless the issue explicitly requires them.

### XML doc comments in test codeunits

XML doc comments (`///`) **cannot** be placed between `Subtype = Test;` and the `var` block — the AL compiler rejects them in that position. Use plain `//` comments there instead.

```al
// CORRECT — plain comment after Subtype declaration
codeunit 50151 "DUOM Foundation Test"
{
    Subtype = Test;

    var
        LibraryAssert: Codeunit "Library Assert";

    // Describes the tests in this codeunit.
    [Test]
    procedure MyTest()
    ...
}

// INCORRECT — /// between Subtype and var causes a compiler error
codeunit 50151 "DUOM Foundation Test"
{
    Subtype = Test;
    /// <summary>This will fail to compile.</summary>
    var
        LibraryAssert: Codeunit "Library Assert";
    ...
}
```

### Field name length

Field names in table extensions must not exceed **30 characters** (compiler error **AL0468**). Always count the full length of `DUOM <Description>` before declaring a new field.

### Object ID ranges

| App | Folder | Range |
|-----|--------|-------|
| Production | `DualUoM/` | 50000 – 50099 |
| Test | `DualUoM.Test/` | 50150 – 50199 |

Each app must use only the range declared in its own `app.json`. Never share ranges between the two apps.

### Test method naming

Test procedure names must follow the `Given/When/Then` pattern:

```
Given<State>_When<Action>_Then<Result>
```

Examples:
- `GivenDUOMDisabled_WhenValidateItemSetup_ThenNoErrorIsRaised`
- `GivenFixedConversionTypeWithZeroRatio_WhenValidateItemSetup_ThenErrorIsRaised`
- `GivenTestApp_WhenLoaded_ThenInfrastructureIsReady`

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
