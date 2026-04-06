---
applyTo: "**/*.al"
---

# AL Development Instructions — DualUoM-BC

## General Principles

- Follow Microsoft's AL best practices and the Business Central extension development guidelines.
- Write clean, readable AL code. Prefer clarity over brevity.
- Every new codeunit, table extension, or page extension must belong to a specific GitHub Issue.
- Do not add functionality outside the scope of the current issue.

## Naming Conventions

| Object type | Pattern | Example |
|-------------|---------|---------|
| Table extension | `DUOM <BaseName> Ext` | `DUOM Item Ext` |
| Page extension | `DUOM <BaseName> Ext` | `DUOM Item Card Ext` |
| Codeunit (production) | `DUOM <Feature Name>` | `DUOM Conversion Calculator` |
| Codeunit (test) | `DUOM <Feature Name> Test` | `DUOM Conversion Calculator Test` |
| Codeunit (test library) | `DUOM Test Library` | `DUOM Test Library` |
| Field names | `DUOM <Description>` | `DUOM Secondary Quantity` |
| Procedure names | PascalCase, descriptive verb-noun | `CalculateSecondaryQuantity` |

## Object ID Ranges

- Use only the object ID range defined in the app's `app.json`.
- Never hardcode object IDs outside of `app.json` range declarations.

## Test-Driven Development Rules

- **Write the test codeunit first.** The test must compile and fail (red) before production code is written.
- Use the `[Test]` attribute on every test procedure.
- Declare the assert helper as `LibraryAssert: Codeunit "Library Assert";` — never use `Assert: Codeunit Assert` (causes AL0185).
- Use `LibraryAssert.AreEqual`, `LibraryAssert.IsTrue`, `LibraryAssert.IsFalse` for assertions — do not use silent checks.
- Name test procedures using the `Given<State>_When<Action>_Then<Result>` pattern.
- Each test procedure must test exactly one behaviour (one logical assertion group).
- Test codeunits must not depend on live company data; always create isolated test records.
- Clean up test data in a `[TearDown]` procedure or by using `Commit()` with isolated test companies.
- Do not place `///` XML doc comments between `Subtype = Test;` and the `var` block — use plain `//` comments there.
- Field names must not exceed 30 characters (AL0468); count the full `DUOM <Description>` length before declaring.

## Code Structure

- Encapsulate all business logic in **codeunits** — not in table or page triggers directly.
- Table and page extensions should call codeunit procedures rather than containing logic inline.
- Use `OnAfterValidate` triggers to react to field changes; call codeunit procedures for the actual logic.
- Avoid using `FIND('-')` / `FIND('+')` loops; prefer `FindSet` with `repeat … until`.

### Facade + Handler pattern

Every feature module **must** follow this two-codeunit pattern:

| Role | Access | Responsibility |
|------|--------|----------------|
| `DUOM <Feature> Facade` | `public` | Thin public API. Delegates all logic to the Handler. No business logic allowed here. |
| `DUOM <Feature> Handler` | `Internal` | Business logic. Never called directly from outside the module. |

Table and page extensions call only the Facade, never the Handler directly.

## No Hardcode

**Never** hardcode values in AL code. Examples of prohibited hardcode:

- Unit of measure codes (`'KG'`, `'PCS'`, `'UN'`, etc.)
- Numeric conversion factors
- Serial numbers, prefixes, or ranges
- Literal error texts outside a `Label` variable
- Record IDs

How to resolve:

1. **Labels** — use `Label` variables (with `Locked = true`) for all string constants.
2. **Setup tables** — use setup tables for values that are user-configurable per company.
3. **Parameters** — pass context values as procedure parameters instead of reading global state.

In test code, define string fixtures as `Label` variables with `Locked = true` (e.g., test UoM codes) to avoid duplicating bare string literals across test methods.

## Performance

- Use `SetLoadFields` to load only the fields required by a procedure before calling `FindSet` or `Get`.
- Apply `SetRange` / `SetFilter` before iterating to avoid loading unneeded records.
- Avoid `Commit()` inside loops.
- Use temporary tables for in-memory processing when the result does not need to be persisted.

## User-Facing Strings and XLIFF

- Every caption, error message, or tooltip visible to users must be a `Label` variable.
- XLIFF files (`.xlf`) are generated automatically by the compiler — do not edit them manually.
- Use `Locked = true` only for strings that must **not** be translated (internal tokens, test fixture codes).

## Error Handling

- Use `Error()` with a descriptive message label (use `Label` variables, not string literals).
- For expected validation failures, raise errors via `FieldError` or `Error` with a named label.
- Do not swallow errors silently.

## AL Patterns

- Use `with` statement sparingly; prefer explicit record variable references for clarity.
- Always check `IsHandled` when raising or subscribing to integration events.
- Use `[IntegrationEvent(false, false)]` for extensibility hooks in codeunits.
- Use `[EventSubscriber]` in separate codeunits — do not mix event subscribers with business logic.

## Linting & Compilation

- The AL-Go CI pipeline compiles the extension and runs all tests automatically.
- Zero compiler warnings are expected (treat warnings as errors in the AL-Go settings).
- Run AL compiler locally before pushing to verify there are no issues.

## Documentation

- Add XML doc comments (`/// <summary>`) to all public codeunit procedures.
- Keep comments up to date — outdated comments are worse than no comments.

## What Not to Do

- Do not implement posting logic unless the issue explicitly requires it.
- Do not add warehouse management features unless the issue explicitly requires it.
- Do not create setup tables or pages unless the issue explicitly requires it.
- Do not use `CODEUNIT.RUN` with global state side-effects; prefer direct procedure calls.
- Do not commit code that causes any existing test to fail.
