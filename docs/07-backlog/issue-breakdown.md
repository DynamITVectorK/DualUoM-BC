# Issue Breakdown — DualUoM Backlog

## How to Use This Document

Each row below represents a planned GitHub Issue. Issues are sized to be small and focused — each should be implementable in a single PR that includes both production code and the corresponding AL tests.

Issues are grouped by Epic (see `epics.md`).

---

## Epic 1 — Project Foundation

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 1 | Create project foundation for TDD-driven development | Docs, copilot instructions, test plan, backlog | This issue — documentation only |

---

## Epic 2 — Item Dual-UoM Setup

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 2 | Add DUOM fields to Item table | Table extension: `DUOM Enabled`, `DUOM Secondary Unit of Measure Code`, `DUOM Default Conversion Factor` | Must include AL tests |
| 3 | Extend Item Card page for DUOM setup | Page extension showing DUOM fields from issue #2 | Depends on #2; must include AL tests |
| 4 | Implement DUOM item setup validation | Codeunit: validate that secondary UoM is set when DUOM is enabled | Must include AL tests covering happy path and error cases |

---

## Epic 3 — Conversion Calculator

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 5 | Implement DUOM Conversion Calculator codeunit | Core calc: Primary Qty × Conversion Factor = Secondary Qty | Must include AL tests for multiple scenarios including zero and negative values |
| 6 | Support variable conversion factor (catch-weight) | Allow the conversion factor to differ per transaction line | Depends on #5; must include AL tests |

---

## Epic 4 — Purchase Order Dual-UoM

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 7 | Add DUOM fields to Purchase Line table | Secondary quantity + conversion factor fields | Must include AL tests |
| 8 | Show DUOM secondary quantity on Purchase Order page | Page extension for purchase lines | Depends on #7; must include AL tests |
| 9 | Auto-populate DUOM secondary quantity on purchase lines | Use conversion calculator when line quantity changes | Depends on #7 and #5; must include AL tests |

---

## Epic 5 — Sales Order Dual-UoM

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 10 | Add DUOM fields to Sales Line table | Secondary quantity + conversion factor fields | Must include AL tests |
| 11 | Show DUOM secondary quantity on Sales Order page | Page extension for sales lines | Depends on #10; must include AL tests |
| 12 | Auto-populate DUOM secondary quantity on sales lines | Use conversion calculator when line quantity changes | Depends on #10 and #5; must include AL tests |

---

## Epic 6 — Item Ledger Entry Dual-UoM

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 13 | Add DUOM fields to Item Ledger Entry table | Secondary quantity + conversion factor fields | Must include AL tests |
| 14 | Populate DUOM fields in Item Ledger Entry on posting | Subscribe to posting events to write dual quantities | Depends on #13, #7, #10; must include AL tests verifying posted entries |

---

## Epic 7 — Reporting

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 15 | Add DUOM columns to Inventory Valuation report | Report extension showing secondary quantities | Depends on #13; must include AL tests |
| 16 | Dual-UoM Item Inquiry page | New page listing items with dual quantities on hand | Depends on #13; must include AL tests |

---

## Epic 8 — Release & Deployment

| # | Title | Scope | Notes |
|---|-------|-------|-------|
| 17 | Prepare v1.0 release | Release notes, version bump, final CI check | After all planned issues are merged |

---

## Guidelines for Creating Issues

When creating a new GitHub Issue from this breakdown:

1. Reference the relevant Epic.
2. Include clear acceptance criteria.
3. State explicitly what AL tests must be written before implementation begins (TDD).
4. Keep the scope to a single logical change — do not bundle multiple epics into one issue.
5. Assign the issue before starting work so Copilot has a focused context.
