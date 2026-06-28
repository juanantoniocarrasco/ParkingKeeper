# AGENTS Guide for `Parking Keeper`
This guide is for agentic coding tools working in this repository.
Use it as the default playbook unless user instructions override it.

Product naming:
- Use `Parking Keeper` in documentation and instructions.
- Code identifiers and paths use `ParkingKeeper` (PascalCase, no spaces).

## Repository Overview
- Main app code: `ParkingKeeper/` (at repo root)
- Main Xcode project: `ParkingKeeper.xcodeproj`
- Main app scheme: `ParkingKeeper`
- Unit tests: `ParkingKeeperTests/`
- UI tests: `ParkingKeeperUITests/`
- No workspace needed (no CocoaPods, targets share one project).

## Build and Lint
Run from repo root.

Preferred local simulator default for development and verification: `iPhone 16 Pro, OS=26.4`.

Build app (Debug):
```bash
xcodebuild -project "ParkingKeeper.xcodeproj" -scheme "ParkingKeeper" -configuration Debug build
```

Build for simulator explicitly:
```bash
xcodebuild -project "ParkingKeeper.xcodeproj" -scheme "ParkingKeeper" -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=26.4' build
```

No SwiftLint is configured.

## Global Engineering Rules
- Keep imports explicit and remove unused imports.
- Use 4-space indentation and keep lines under ~135 chars when practical.
- Prefer `struct` for value/domain types.
- Domain entities are immutable value types (all properties are `let`). Each entity provides an `updated(...)` method that returns a new instance with selective field changes.
- Views manage their own presentation logic. Use `@State` for local state and helper types when a view grows too large. `@Observable final class` ViewModels are reserved exclusively for sharing state across two or more views. Never create a ViewModel for a single view.
- All views follow the body-as-index pattern: `body` only composes subviews declared as `var` or `func` in a `private extension ViewName` under `// MARK: - Subviews`. Inline view trees in `body` beyond trivial one-child wrappers (e.g. `NavigationStack { detail }`) are forbidden.
- Inject dependencies through initializers.
- Prefer `async/await` and use `@MainActor` for UI-observed state mutation.
- Keep tests focused on outcomes; use deterministic assertions.

## Naming Conventions
- SwiftData `@Model` classes use the `*PersistentModel` suffix (e.g., `ClientPersistentModel`) to avoid confusion with view models.
- Data mappers use the `*DataMapper` suffix (e.g., `ClientDataMapper`) to distinguish from potential future `ViewMapper` types.
- Domain entity identifiers use `UUID` (Vehicle ID as license plate is deferred to a future refactor).

## Feature Structure (Global)
For new feature work, use folder structure `Features/<FeatureName>/` and keep dependency direction:
- `Presentation -> Domain`
- `Data -> Domain`
- `Composition` wires dependencies.

Each feature's folder structure is flat (no subdirectories under Domain/Data):
```
Features/<Feature>/
├── Domain/
│   ├── <Feature>.swift
│   ├── <Feature>RepositoryProtocol.swift
│   └── <Feature>Logic.swift
├── Data/
│   ├── <Feature>PersistentModel.swift
│   ├── <Feature>Repository.swift
│   └── <Feature>DataMapper.swift
└── Composition/
    ── <Feature>Assembler.swift
```

Each feature's domain layer contains:
- Entity structs (`Client`, `Vehicle`, etc.) — immutable with `updated()` methods
- Repository protocols (`ClientRepositoryProtocol`)
- Feature logic structs (`ClientLogic`) with business functions per entity

## Tech Stack
- **UI**: SwiftUI (iOS 18+, macOS 15+)
- **Persistence**: SwiftData (`@Model`) with CloudKit sync
- **Sync**: CloudKit (iCloud container), free tier
- **Observation**: `@Observable` (iOS 17+ macro)
- **Navigation**: `NavigationStack` + `NavigationSplitView`
- **Networking**: URLSession (async/await)
- **Packages**: SPM only, no CocoaPods

## Skills (Mandatory for Scope Rules)
Project skills are stored in `.agents/skills/`.

- `parking-keeper-presentation`: SwiftUI presentation architecture, view boundaries, PK design-system tokens, previews, localized strings, presentation DoD.
- `parking-keeper-navigation`: App-level navigation architecture (`AppRootView`, `PKScreen`, `NavigationCoordinator`) and navigation DoD.
- `parking-keeper-data`: SwiftData model architecture, repository/datasource patterns, mapper boundaries, data DoD.
- `parking-keeper-domain`: Domain logic rules. Each entity has a `Logic` struct with business functions, domain error mapping, domain testing requirements, domain DoD.

Load the relevant skill before implementing scope-specific changes.

## Interaction Skills
- `grill-me`: plan and design interrogation workflow. Use it to resolve one decision at a time, with a recommended answer, when the user is planning, brainstorming, or stress-testing an approach.

### Skills Loading Matrix
- Presentation scope (SwiftUI views/view models/UI state/previews/localizable strings): load `parking-keeper-presentation`.
- Navigation scope (`AppRootView`, `PKScreen`, `NavigationCoordinator`, routing/presentation mode): load `parking-keeper-navigation`.
- Data scope (SwiftData models/repositories/mappers): load `parking-keeper-data`.
- Domain scope (business rules/feature logic/domain errors/domain tests): load `parking-keeper-domain`.
- Cross-scope work: load only missing skills for newly touched scopes; never reload already loaded skills.

## Sensitive Information
This repository may be public. Never commit:
- Concrete business rules, pricing models, or operational details
- API keys, tokens, certificates, or secrets
- Internal URLs, server addresses, or infrastructure details
- Real client data or credentials
Domain details needed during development stay in agent conversation context only.

## Recommended Agent Workflow
- **At the start of every conversation, read `ROADMAP.md`** to pick up where the last session left off.
- Inspect nearby files before editing to match local architecture and style.
- When the user intent is planning rather than implementation, proactively load `grill-me` even if the user does not mention it by name.
- Use `grill-me` for design reviews, implementation planning, architecture tradeoffs, and ambiguity reduction before coding.
- Keep changes scoped; avoid unrelated refactors.
- Run the narrowest relevant test first, then broaden if needed.
- For app code changes, run relevant tests.

## Global Definition of Done
- Changes respect repository conventions and architecture boundaries.
- Relevant skill rules were loaded and followed for each touched scope.
- Relevant tests were run (or blockers clearly documented).
- No unrelated refactors or naming migrations were introduced.
- Scope-specific DoD from each loaded skill is satisfied.

## Git Conventions
Use [Conventional Commits](https://www.conventionalcommits.org/) for all commit messages:

- `feat:` — new feature
- `fix:` — bug fix
- `refactor:` — code restructuring without behavior change
- `test:` — adding or updating tests
- `docs:` — documentation, AGENTS.md, skills, comments
- `chore:` — build, CI, dependencies, project config

Keep messages concise and scoped (e.g., `feat(clients): add client list view with search`).

## Subagent Usage
Delegate work to subagents to reduce context window and token consumption:

- **Codebase exploration**: use the `explore` subagent for searches across multiple files, finding patterns, or answering questions about the codebase.
- **Feature implementation**: when a feature touches multiple layers (Presentation + Domain + Data), delegate the full implementation to a subagent with clear scope boundaries.
- **Refactors**: isolated refactors within one feature or module go to a subagent.
- **Test suite runs**: offload builds and test execution to subagents when verification is needed.

Do NOT use subagents for single-file edits, simple questions, or navigation/file reads.
