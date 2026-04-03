# Test Plan — DualUoM

## Philosophy: Test-Driven Development (TDD)

This project follows a **Test-Driven Development** approach for all new functionality:

1. **Write a failing test first** — before writing any production AL code, create an AL test codeunit that asserts the expected behaviour.
2. **Write the minimum production code** to make the test pass.
3. **Refactor** — improve the code without breaking the tests.
4. **Never merge untested code** — compilation alone is not sufficient for acceptance. Every pull request must include passing AL tests that cover the changed functionality.

## Test Layers

### Unit Tests

- Target individual codeunit procedures.
- Use isolated, in-memory test data wherever possible.
- Mock or stub dependencies that involve posting or external services.
- Naming convention: `DUOM <FeatureName> Test` (e.g. `DUOM Conversion Calculator Test`).

### Integration Tests

- Test end-to-end flows within Business Central (e.g. posting a sales order and verifying item ledger entries).
- Use standard AL test libraries to set up and tear down test data.
- Should cover happy-path and key error-path scenarios.

### Regression Tests

- Existing tests must not be broken by new changes.
- AL-Go CI pipeline runs all tests on every push to a PR branch.

## Test Coverage Requirements

| Feature Area | Minimum Coverage |
|--------------|-----------------|
| DUOM item setup validation | Happy path + validation errors |
| Conversion calculator | Multiple conversion scenarios including edge cases (zero, negative) |
| Sales line dual-quantity | Population, override, and recalculation |
| Purchase line dual-quantity | Population, override, and recalculation |
| Item ledger entry dual fields | Populated correctly after posting |

## AL Test Infrastructure

- Test codeunits reside in a dedicated **test app** within the AL-Go project structure (separate `app.json`).
- The test app depends on the production app.
- Test helper codeunits (library) are prefixed `DUOM Test Library`.
- All test procedures use `[Test]` attribute and are wrapped in an `[ErrorBehavior(ErrorBehavior::Collect)]` block where multiple assertions are needed.

## CI/CD Integration

- The AL-Go `Current.yaml`, `NextMinor.yaml` and `NextMajor.yaml` workflows compile and run all tests automatically.
- A PR cannot be merged if any test fails.
- Test results are published as workflow artifacts and visible in the GitHub Actions summary.

## Definition of Done

A feature is considered **done** when:

- [ ] All acceptance criteria from the issue are met.
- [ ] At least one AL test codeunit covers the new functionality.
- [ ] All existing tests still pass.
- [ ] Code has been reviewed and approved.
- [ ] PR has been merged into the default branch via AL-Go CI.
