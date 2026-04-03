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
- Use `Assert.AreEqual`, `Assert.IsTrue`, `Assert.IsFalse`, and `Error` for assertions — do not use silent checks.
- Each test procedure must test exactly one behaviour (one logical assertion group).
- Test codeunits must not depend on live company data; always create isolated test records.
- Clean up test data in a `[TearDown]` procedure or by using `Commit()` with isolated test companies.

## Code Structure

- Encapsulate all business logic in **codeunits** — not in table or page triggers directly.
- Table and page extensions should call codeunit procedures rather than containing logic inline.
- Use `OnAfterValidate` triggers to react to field changes; call codeunit procedures for the actual logic.
- Avoid using `FIND('-')` / `FIND('+')` loops; prefer `FindSet` with `repeat … until`.

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
