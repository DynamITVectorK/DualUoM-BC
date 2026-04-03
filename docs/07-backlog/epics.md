# Epics — DualUoM Backlog

## Overview

This document lists the high-level epics for the DualUoM project. Each epic is broken down into individual GitHub Issues in `issue-breakdown.md`.

---

## Epic 1 — Project Foundation

**Goal:** Prepare the repository, documentation, and development guidelines for TDD-driven development.

**Scope:**
- Repository documentation structure (`/docs`)
- Copilot and AL development instructions
- Test plan and TDD guidelines
- Backlog structure

**Status:** In Progress

---

## Epic 2 — Item Dual-UoM Setup

**Goal:** Allow items to be configured with a secondary unit of measure.

**Scope:**
- Extend the `Item` table with dual-UoM fields
- Extend the `Item Card` page to expose dual-UoM setup fields
- Implement setup validation rules (codeunit)
- AL tests for item setup

**Status:** Planned

---

## Epic 3 — Conversion Calculator

**Goal:** Implement the core calculation logic that converts between primary and secondary UoM quantities.

**Scope:**
- `DUOM Conversion Calculator` codeunit
- Support for fixed and variable (catch-weight) conversion factors
- Full AL test coverage

**Status:** Planned

---

## Epic 4 — Purchase Order Dual-UoM

**Goal:** Capture dual quantities on purchase order lines for dual-UoM items.

**Scope:**
- Extend `Purchase Line` table with secondary quantity and conversion factor fields
- Extend purchase order page to show secondary quantity
- Auto-populate secondary quantity using conversion calculator
- Allow override (catch-weight)
- AL tests

**Status:** Planned

---

## Epic 5 — Sales Order Dual-UoM

**Goal:** Capture dual quantities on sales order lines for dual-UoM items.

**Scope:**
- Extend `Sales Line` table with secondary quantity and conversion factor fields
- Extend sales order page
- Auto-populate and override logic
- AL tests

**Status:** Planned

---

## Epic 6 — Item Ledger Entry Dual-UoM

**Goal:** Persist dual quantities in item ledger entries after posting.

**Scope:**
- Extend `Item Ledger Entry` table
- Ensure dual quantities are written during posting
- AL tests verifying posted entries

**Status:** Planned

---

## Epic 7 — Reporting

**Goal:** Surface dual-UoM quantities in existing and new reports/pages.

**Scope:**
- Inventory valuation report extension
- Item movement report extension
- Optional: dedicated dual-UoM inquiry page

**Status:** Planned

---

## Epic 8 — Release & Deployment

**Goal:** Package and release the extension via AL-Go.

**Scope:**
- Version management
- Release notes
- AppSource / PTE deployment checklist

**Status:** Planned
