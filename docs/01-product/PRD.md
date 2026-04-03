# Product Requirements Document — Dual Unit of Measure (DualUoM)

## Overview

DualUoM is a Per-Tenant Extension (PTE) for Microsoft Dynamics 365 Business Central SaaS. It extends the standard item unit-of-measure model to support a **dual unit-of-measure** pattern, allowing items to be tracked simultaneously in two independent units (e.g. pieces and kilograms).

## Problem Statement

Standard Business Central records item quantities in a single base unit of measure. Industries such as food & beverage, chemicals, and manufacturing frequently need to track and transact items in two units simultaneously — for example, selling fish by the piece while tracking inventory weight in kilograms. Without this capability, users must maintain manual conversions or parallel spreadsheets, leading to data inconsistency and audit risk.

## Goals

1. Allow each item to define a **primary UoM** and an optional **secondary UoM**.
2. Capture quantity in both units on sales, purchase, and inventory transactions.
3. Support configurable conversion factors between the two units (fixed or variable catch-weight).
4. Maintain full auditability and traceability in both units.

## Non-Goals (initial scope)

- Warehouse Management System (WMS) integration is out of scope for initial releases.
- Advanced pricing by secondary UoM is out of scope for initial releases.
- No changes to posting logic beyond what is required for dual-quantity capture.

## Success Criteria

- Items can be flagged as dual-UoM items.
- Transactions record both quantities and the applicable conversion factor.
- Reports reflect dual quantities accurately.
- All functionality is covered by automated AL tests (TDD approach).

## Stakeholders

| Role | Name / Group |
|------|--------------|
| Product Owner | DynamITVectorK |
| Development | GitHub Copilot (AI) + human reviewer |
| QA | Automated AL tests + human review |

## Constraints

- Must be a PTE deployable to Business Central SaaS (no on-premises assumptions).
- Must follow AL-Go CI/CD pipeline conventions.
- Must comply with Business Central extension best practices (AppSource / PTE guidelines).
