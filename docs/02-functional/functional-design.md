# Functional Design — Dual Unit of Measure (DualUoM)

## Scope

This document describes the functional behaviour of the DualUoM extension from a user and process perspective. It does not contain technical implementation details (see the architecture document for those).

## Key Concepts

| Concept | Description |
|---------|-------------|
| Primary UoM | The standard Business Central base unit of measure for the item (e.g. PCS) |
| Secondary UoM | An additional unit used to track the same item quantity in parallel (e.g. KG) |
| Conversion Factor | The ratio used to convert between Primary UoM and Secondary UoM. May be fixed or variable (catch-weight). |
| Dual-UoM Item | An item for which the Secondary UoM feature is activated |

## Functional Areas

### 1. Item Setup

- A new toggle on the Item Card enables the dual-UoM feature for an item.
- When enabled, the user must select a Secondary UoM from the existing Units of Measure table.
- A default conversion factor (Primary → Secondary) can be specified.
- Items without the toggle remain unaffected.

### 2. Purchase Transactions

- On purchase order lines for dual-UoM items, a secondary quantity field is shown.
- The secondary quantity is pre-filled using the conversion factor but can be overridden (catch-weight scenario).

### 3. Sales Transactions

- On sales order lines for dual-UoM items, both quantities are captured and stored.
- Invoicing reflects both units for reporting purposes.

### 4. Inventory Adjustments

- Item journal lines for dual-UoM items capture quantity in both units.
- The secondary quantity can deviate from the calculated value (variable catch-weight).

### 5. Reporting

- Inventory valuation and movement reports show both primary and secondary quantities where applicable.

## User Stories (high level)

1. **As a purchasing agent**, I want to record the actual weight of fish received (secondary UoM = KG) against the ordered quantity in pieces (primary UoM = PCS), so that inventory reflects the true weight on hand.
2. **As a warehouse operator**, I want to see both piece count and weight for dual-UoM items, so that I can plan pick operations correctly.
3. **As a finance controller**, I want reports to reflect both units of measure, so that I can reconcile inventory value with weight-based pricing.

## Out of Scope

- WMS integration
- Advanced pricing rules based on secondary UoM
- Production order dual-UoM tracking (future phase)
