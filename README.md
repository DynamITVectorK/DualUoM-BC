# DualUoM for Business Central

**DualUoM** is a Per-Tenant Extension (PTE) for Microsoft Dynamics 365 Business Central SaaS.  
It extends the standard `Item` table so that item quantities can be tracked simultaneously in two independent units of measure — for example, pieces *and* kilograms on the same transaction line.

---

## Features

### Item Setup (implemented)

A new **Dual Unit of Measure** FastTab is added to the Item Card, exposing the following fields:

| Field | Type | Description |
|---|---|---|
| **DUOM Enabled** | Boolean | Activates dual-UoM tracking for the item. |
| **DUOM Secondary UoM Code** | Code[10] | The secondary unit of measure (must be a valid `Unit of Measure`). Required when DUOM is enabled. |
| **DUOM Conversion Type** | Enum | How the conversion factor is determined: `Fixed`, `Variable`, or `Always Variable`. |
| **DUOM Fixed Ratio** | Decimal (0:5) | The fixed conversion ratio from the primary to the secondary unit. Required and must be > 0 when Conversion Type is `Fixed`. |

**Validation rules** enforced on every field change:

- When DUOM is disabled, no other fields are required.  
- When DUOM is enabled, **DUOM Secondary UoM Code** must be supplied.  
- When Conversion Type is `Fixed`, **DUOM Fixed Ratio** must be greater than zero.  
- `Variable` and `Always Variable` conversion types do not require a fixed ratio.

---

## Repository Structure

```
DualUoM/                        # Production app (IDs 50000–50099)
├── app.json
└── src/
    ├── Codeunits/
    │   ├── DUOMSetupManagement.Codeunit.al     # Public facade (DUOM Item Setup Facade)
    │   └── DUOMItemSetupHandler.Codeunit.al    # Internal handler with validation logic
    ├── Enum/
    │   └── DUOMConversionType.Enum.al          # Fixed / Variable / Always Variable
    ├── PageExtensions/
    │   └── DUOMItemCardExt.PageExt.al          # Adds DUOM group to Item Card
    └── TableExtensions/
        └── DUOMItemExt.TableExt.al             # Adds DUOM fields to Item table

DualUoM.Test/                   # Test app (IDs 50150–50199)
├── app.json
└── src/
    ├── DUOMTestLibrary.Codeunit.al             # Shared test helpers / record factories
    ├── DUOMFoundationTest.Codeunit.al          # Smoke test – infrastructure check
    └── DUOMItemSetupTest.Codeunit.al           # Validation rule tests for item setup

docs/                           # Product and architecture documentation
.github/                        # AL-Go CI/CD workflows and Copilot instructions
```

---

## Architecture

The extension follows a **Facade + Handler** pattern for all business logic:

- **`DUOM Item Setup Facade`** (codeunit 50000, `public`) — the single entry point consumed by table/page extensions.  
- **`DUOM Item Setup Handler`** (codeunit 50001, `Access = Internal`) — contains the actual validation logic; not callable from outside the app.

Table and page extensions invoke the facade from `OnValidate` triggers; they contain no inline business logic.

---

## Development

### Prerequisites

- Visual Studio Code with the [AL Language extension](https://marketplace.visualstudio.com/items?itemName=ms-dynamics-smb.al)
- Access to a Business Central 25.x (or later) sandbox or Docker container
- [AL-Go for GitHub](https://aka.ms/AL-Go) configured in this repository for CI/CD

### Object ID Ranges

| App | Range |
|---|---|
| Production (`DualUoM/`) | 50000 – 50099 |
| Test (`DualUoM.Test/`) | 50150 – 50199 |

### CI/CD

All pull requests are validated automatically by the AL-Go workflow, which:

1. Compiles both the production app and the test app.
2. Runs all AL test codeunits against a Business Central container.
3. Reports pass/fail status back to the pull request.

Zero compiler warnings are required (warnings are treated as errors).

---

## Testing

Tests follow the **Given/When/Then** naming convention and use the `Library Assert` codeunit for assertions.

```al
// Example test method name
GivenFixedConversionTypeWithZeroRatio_WhenValidateItemSetup_ThenErrorIsRaised()
```

Key test codeunits:

| Codeunit | ID | Purpose |
|---|---|---|
| `DUOM Test Library` | 50150 | Shared helper / record factory procedures |
| `DUOM Foundation Test` | 50151 | Smoke test verifying the test infrastructure |
| `DUOM Item Setup Test` | 50152 | Validation rules for per-item DUOM configuration |

---

## Contributing

1. Pick an open issue from the [backlog](./docs/07-backlog/issue-breakdown.md).
2. Create a feature branch named `feature/<issue-number>-short-description`.
3. Write the AL test codeunit **before** writing production code (TDD).
4. Open a pull request — the AL-Go workflow runs automatically.
5. A human reviewer must approve before merging.

Please read [`.github/copilot-instructions.md`](.github/copilot-instructions.md) for coding standards and conventions used in this project.

---

## License

See [SECURITY.md](SECURITY.md) and [SUPPORT.md](SUPPORT.md) for security and support information.
