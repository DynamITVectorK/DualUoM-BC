# GitHub Copilot Instructions — DualUoM-BC

## Project Summary

This repository contains **DualUoM**, a Per-Tenant Extension (PTE) for Microsoft Dynamics 365 Business Central SaaS. The extension implements a dual unit-of-measure model for items, allowing quantities to be tracked simultaneously in two independent units (e.g. pieces and kilograms).

## Core Principles

These principles apply to **all** work in this repository:

- **Extension-only development** — Never modify base application objects. Use tableextensions, pageextensions, and event subscribers exclusively.
- **Issue-focused increments** — Each pull request must address exactly one GitHub Issue. Do not implement functionality described in other issues.
- **Test-Driven Development (TDD)** — Write the test codeunit before production code. A feature is complete only when its AL tests pass in the AL-Go CI pipeline.
- **No hardcode** — Never embed literal UoM codes, conversion factors, or magic strings. Use `Label` variables, setup tables, and procedure parameters.
- **Scope discipline** — Do not add posting, warehouse, setup tables, or pages unless the issue explicitly requires them.
- **Human-in-the-Loop** — Flag any decision that changes existing behaviour or architecture in a PR comment before implementing it.

### Issue-focused increments (detail)

- Do not implement functionality that is described in other issues, even if it seems related or convenient.
- If completing the current issue requires a change that belongs to a different issue, stop and flag this in a PR comment rather than implementing it silently.

### TDD (detail)

- Tests must cover the happy path and key error/edge-case paths defined in the issue acceptance criteria.
- Do not merge code that causes existing tests to fail.

### Scope discipline (detail)

- Do not add posting logic unless the issue explicitly requires it.
- Do not add warehouse management logic unless the issue explicitly requires it.
- Do not create setup tables or pages unless the issue explicitly requires it.
- Do not implement DUOM business functionality in issues that are marked as documentation or foundation only.

## Feature Work Routing

Use the table below to choose the right implementation approach based on scope:

| Complexity | Criteria | Approach |
|------------|----------|----------|
| **LOW** | Single object, no integrations | Write spec comment in issue → implement directly |
| **MEDIUM** | 2–3 objects, internal integrations | Draft architecture note in issue → TDD cycle |
| **HIGH** | 4+ objects, cross-module, posting | Full design document in `docs/` → phased TDD |

When in doubt, start at MEDIUM and escalate.

## AL Coding Standards

Refer to `/.github/instructions/al.instructions.md` for the complete set of AL language rules and conventions. The sections below highlight the most critical rules for this project.

### Architecture: Facade + Handler

Every feature module **must** follow the Facade + Handler pattern:

| Role | Access | Responsibility |
|------|--------|----------------|
| `DUOM <Feature> Facade` | `public` | Single public API consumed by extensions and other modules. Contains no business logic — delegates entirely to the Handler. |
| `DUOM <Feature> Handler` | `Internal` | Contains all business logic. Never called directly from outside the module. |

```al
// Table/page extension: call Facade only
trigger OnValidate()
var
    DUOMItemSetupFacade: Codeunit "DUOM Item Setup Facade";
begin
    DUOMItemSetupFacade.ValidateItemSetup(Rec);
end;

// Facade: thin delegation layer
procedure ValidateItemSetup(Item: Record Item)
var
    DUOMItemSetupHandler: Codeunit "DUOM Item Setup Handler";
begin
    DUOMItemSetupHandler.ValidateItemSetup(Item);
end;

// Handler (Access = Internal): business logic lives here
codeunit 50001 "DUOM Item Setup Handler"
{
    Access = Internal;
    procedure ValidateItemSetup(Item: Record Item) ...
}
```

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

### Performance

- Use `SetLoadFields` to load only the fields needed by a procedure.
- Filter records as early as possible before iterating (`SetRange`, `SetFilter`).
- Prefer `FindSet` with `repeat … until Next() = 0` over `Find('-')` / `Find('+')` loops.
- Avoid unnecessary `Commit()` calls inside loops.
- Use temporary tables for in-memory processing when the result set is not persisted.

### User-facing strings and XLIFF

- Every user-visible string (captions, error messages, tooltips) must be declared as a `Label` variable.
- XLIFF translation files are generated automatically by the AL compiler — do not edit `.xlf` files manually.
- Use `Locked = true` only for strings that must **not** be translated (internal tokens, UoM fixture codes in tests).

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
├── DualUoM/                      # Production extension (IDs 50000–50099)
│   ├── app.json
│   └── src/
│       ├── Codeunits/           # Facade + Handler codeunits
│       ├── Enum/
│       ├── PageExtensions/
│       └── TableExtensions/
└── DualUoM.Test/                 # Test extension (IDs 50150–50199)
    ├── app.json
    └── src/                     # Test codeunits and test library
```

## Definition of Done

A pull request is ready to merge when:

- [ ] All acceptance criteria from the linked issue are met.
- [ ] AL tests covering the new functionality are included and pass.
- [ ] All pre-existing tests continue to pass.
- [ ] Code follows the AL conventions in `al.instructions.md`.
- [ ] The PR scope is limited to the assigned issue — no unrelated changes.
- [ ] A human reviewer has approved the PR.

## Reference Documentation

### Microsoft Documentation

- [AL Language Reference](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-reference-overview)
- [Business Central Extension Development](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/)
- [AL-Go for GitHub](https://github.com/microsoft/AL-Go)
- [Table Extension (AL)](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-table-ext-object)
- [Event Subscribers (AL)](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-subscribing-to-events)

### This Project's Documentation

- [Functional Design](../docs/02-functional/functional-design.md)
- [Architecture & Data Model](../docs/03-architecture/architecture-data-model.md)
- [Test Plan](../docs/06-testing/test-plan.md)
- [AL Development Instructions](instructions/al.instructions.md)

## Copilot Interaction Tips

### 1. Provide context up front

> "I'm implementing issue #42 — adding a secondary UoM quantity field to item ledger entries."

Avoid vague prompts like "add a field".

### 2. Reference the pattern

Ask Copilot to follow the Facade + Handler pattern explicitly if generating codeunits:

> "Generate a Facade codeunit and an internal Handler codeunit following the DualUoM Facade+Handler pattern."

### 3. Always review generated code

- Verify all strings are declared as `Label` variables (no hardcode).
- Confirm object IDs are within the correct app range.
- Check field name lengths do not exceed 30 characters.
- Ensure test procedures use `LibraryAssert`, not `Assert`.

### 4. Use `al.instructions.md` for style

The auto-applied instruction file `.github/instructions/al.instructions.md` governs naming, structure, and patterns. You do not need to repeat those rules in every prompt — they are active on all `*.al` files.
