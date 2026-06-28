---
name: parking-keeper-presentation
description: SwiftUI presentation architecture and PK design-system rules for Parking Keeper. Use when creating or modifying views, view models, UI state, localizable strings, previews, or code under Presentation layers.
---

# Parking Keeper Presentation

## Scope
- In scope: SwiftUI views, presentation-only state, view model contracts, localizable UI text, preview coverage, PK design-system token usage.
- Out of scope: navigation coordination internals, repository/persistence code, domain decision logic.

## Workflow
1. Read nearby feature files to match naming and boundaries.
2. Implement changes with presentation-only responsibilities.
3. Run relevant tests.

## Conventions
- Views are `struct ViewName: View`, organized as `ViewName.swift`.
- **Body-as-index pattern (MANDATORY):** Every `body` must only compose subviews declared as `var`/`func` in a `private extension ViewName` under `// MARK: - Subviews`. The `body` itself must not contain inline view builders, stacked modifiers, or multi-child view trees — only trivial one-child wrappers (e.g. `NavigationSplitView { sidebar } detail: { detail }`). Subviews must also be decomposed the same way recursively if they grow beyond a few lines.
- Views manage their own presentation logic using `@State`. Use helper types (`struct ViewNameHelper`) when a view grows too large.
- `@Observable final class` ViewModels are reserved exclusively for sharing state across two or more views.
- Subviews live as computed properties in a `private extension ViewName`.
- Feature-local constants (layout, sizing) belong in a nested `enum Constants`.
- Localized strings belong in a nested `enum Localizables` of type `LocalizedStringKey`.
- Every new view must include a representative `#Preview` macro at the bottom of the file.
- No direct model context or repository access inside views — use helpers or domain services injected through initializers.

### View Property Order

Inside a view struct body, declare properties in this order:

1. `@Environment` / `@EnvironmentObject` — injected dependencies from SwiftUI environment
2. `@State` — local mutable state
3. `@Binding` — two-way bindings from parent
4. `@StateObject` — owned observable objects (rare; prefer `@State` or helpers)
5. `private let` — injected dependencies (logic, repository, services)
6. `private let model: Model` — the view's presentation model struct (immutable `let` properties)
7. Other computed/general properties

## File Organization

Every SwiftUI view file must organize its `private extension` blocks in this order:

1. `// MARK: - Subviews` — `var body` and all `var xxx: some View` subview computed properties
2. `// MARK: - Methods` — `private func` handlers for taps, gestures, callbacks, navigation
3. `// MARK: - Computed` — non-view computed properties (Bool, String, derived values)
4. `// MARK: - Alerts` — `var xxxAlert: Alert` or custom alert definitions (if any)
5. Remaining extensions in logical dependency order
6. `// MARK: - Constants & Localizables` — `enum Constants` and `enum Localizables` in the same extension block
7. `// MARK: - Subtypes` — `struct Model`, `enum ViewState`, nested type aliases, and other view-owned types

   The `Model` is a nested `struct` with all `let` properties. It is the immutable presentation state the view renders. Example:

   ```swift
   // MARK: - Subtypes
   extension ClientListView {
       struct Model {
           let clients: [Client]
           let searchText: String
           let isLoading: Bool
       }
   }
   ```

   The `#Preview` injects it with mock data:

   ```swift
   #Preview {
       ClientListView(model: .init(clients: [.mock()], searchText: "", isLoading: false))
   }
   ```

8. `#Preview` — at the end of the file

Extensions should be `private extension` unless the types/members are used externally. Standalone helper views in the same file go between the main view and its extensions.

Split files that exceed roughly 250 lines or start mixing unrelated concerns.

## Design System
- A PK design system will be built over time. For now, use native SwiftUI primitives.
- When the PK design system is created, all views must use PK tokens (colors, spacing, fonts, components) instead of raw values.
- No use of system fonts, raw `Color.white`, hardcoded spacing, or ad-hoc components in production UI once PK tokens exist.

## Cross-Skill Triggers
- Load `parking-keeper-navigation` when changes touch app-level routing or screen definitions.
- Load `parking-keeper-domain` when moving business rules out of views.
- Load `parking-keeper-data` when adding/changing repositories, SwiftData models, or persistence.

## Presentation DoD
- Presentation boundaries are respected (no data access from views).
- UI state ownership is clear and single-source (via `@State` for single views, `@Observable` ViewModel only for shared state).
- Localized strings and constants are organized correctly.
- Representative `#Preview` is present for new views.
