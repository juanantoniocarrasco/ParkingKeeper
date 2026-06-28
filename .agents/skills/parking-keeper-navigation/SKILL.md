---
name: parking-keeper-navigation
description: App-level navigation architecture rules for Parking Keeper. Use when adding or changing screen routing, root replacement, stack pushes, sheets, full screen flows, or typed screen definitions.
---

# Parking Keeper Navigation

## Scope
- In scope: app-level routing contracts, typed screen definitions, presentation mode semantics.
- Out of scope: view styling/tokens, repository construction, domain decision logic.

## Conventions
- The app uses `NavigationStack` (iOS/macOS) and may use `NavigationSplitView` for sidebar detail layouts.
- Screen routing is centralized through a typed screen enum and a navigation coordinator.
- Presentation modes: push, sheet, fullScreenCover.
- Feature assemblers create screens from typed screen cases.
- Views access navigation via `@Environment(NavigationCoordinator.self)` or `.environment()`.

## Workflow
1. Read the existing navigation files (coordinator, screen enum, root view) before editing.
2. Add or update typed screen cases.
3. Keep route composition using assemblers.
4. Trigger state transitions only through coordinator APIs.
5. Verify push, sheet, and full-screen behavior and run relevant tests.

## Cross-Skill Triggers
- Load `parking-keeper-presentation` when navigation changes require view contract updates.
- Load `parking-keeper-data` when screen routing depends on data state transitions.
- Load `parking-keeper-domain` when navigation is driven by business rule outcomes.

## Navigation DoD
- New navigation flows are represented through typed screen cases.
- Navigation state changes go through coordinator APIs.
- The root view remains the single navigation composition root.
- Any sheet/full-screen behavior uses defined presentation modes.
- No feature-specific navigation hacks bypassing coordinator contracts.
