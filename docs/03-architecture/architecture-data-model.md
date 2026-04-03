# Architecture & Data Model — Dual Unit of Measure (DualUoM)

## Overview

DualUoM is implemented as a Business Central Per-Tenant Extension using table extensions, page extensions, and codeunits. It follows a non-invasive extension pattern: no base application objects are modified beyond what the standard extensibility framework allows.

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Platform | Microsoft Dynamics 365 Business Central SaaS |
| Language | AL (Application Language) |
| CI/CD | AL-Go for GitHub |
| Testing | AL Test Framework (Test codeunits) |
| Source control | GitHub |

## Data Model

### Extended Tables

#### `Item` (table extension)

| Field Name | Type | Description |
|------------|------|-------------|
| `DUOM Enabled` | Boolean | Activates dual-UoM tracking for this item |
| `DUOM Secondary Unit of Measure Code` | Code[10] | References `Unit of Measure` |
| `DUOM Default Conversion Factor` | Decimal | Default Primary → Secondary conversion ratio |

#### `Sales Line` (table extension)

| Field Name | Type | Description |
|------------|------|-------------|
| `DUOM Secondary Quantity` | Decimal | Quantity in secondary UoM |
| `DUOM Conversion Factor` | Decimal | Actual conversion factor used on this line |

#### `Purchase Line` (table extension)

| Field Name | Type | Description |
|------------|------|-------------|
| `DUOM Secondary Quantity` | Decimal | Quantity in secondary UoM |
| `DUOM Conversion Factor` | Decimal | Actual conversion factor used on this line |

#### `Item Ledger Entry` (table extension)

| Field Name | Type | Description |
|------------|------|-------------|
| `DUOM Secondary Quantity` | Decimal | Posted quantity in secondary UoM |
| `DUOM Conversion Factor` | Decimal | Conversion factor at time of posting |

> **Note:** Table extensions above represent the *intended* target model. Fields will be implemented in individual issues — see the backlog for the planned sequence.

## Key Codeunits (planned)

| Codeunit | Responsibility |
|----------|---------------|
| `DUOM Setup Management` | Validates item dual-UoM setup rules |
| `DUOM Conversion Calculator` | Computes secondary quantities from primary quantities and conversion factors |
| `DUOM Line Handler` | Applies dual-UoM logic to transaction lines (sales, purchase, journals) |

## Extension Pattern

- All AL objects use the reserved object-ID range assigned to this PTE.
- No base application procedures are modified; extensibility hooks (events, table extensions, page extensions) are used exclusively.
- Business logic is encapsulated in codeunits to maximise testability.

## Testing Architecture

- Each codeunit has a corresponding test codeunit.
- Test codeunits use the `[Test]` and `[TestFixture]` attributes.
- Test helpers (libraries) create isolated test data and are never shared with production objects.
- Tests must pass in the AL-Go CI pipeline before any PR can be merged.

## Object ID Ranges

Object ID ranges will be confirmed in the AL-Go settings (`app.json`) once the first app is scaffolded. All objects must fall within the assigned range.
