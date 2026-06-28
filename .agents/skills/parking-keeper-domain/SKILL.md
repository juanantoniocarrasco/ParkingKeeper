---
name: parking-keeper-domain
description: Domain logic rules for Parking Keeper. Use when implementing or refactoring business logic, use cases, entity design, domain error mapping, or domain-focused test coverage.
---

# Parking Keeper Domain

## Scope
- In scope: domain entities, feature logic structs, repository protocols, business rules, domain errors.
- Out of scope: SwiftUI views, app navigation, SwiftData persistence details.

## Workflow
1. Inspect existing entities and logic structs for conventions.
2. Design domain entities as immutable value types (all `let` properties).
3. Provide `updated(...)` methods that return new instances with selective field changes.
4. Define repository protocols in the Domain layer.
5. Keep logic structs focused on business rules per entity.
6. Run relevant tests.

## Conventions
- Domain entities are immutable `struct` types conforming to `Identifiable` and `Hashable`.
- Each entity provides `func updated(...) -> Self` with optional parameters defaulting to current values.
- Entity identifiers use `UUID`.
- Repository protocols define the contract in `<Feature>/Domain/<Feature>RepositoryProtocol.swift`.
- Feature logic structs live in `<Feature>/Domain/<Feature>Logic.swift`.
- Domain layer never imports SwiftData or any data-layer framework.
- Domain errors use explicit enum types, not raw strings.

## Cross-Skill Triggers
- Load `parking-keeper-data` when repository protocol changes require data-layer updates.
- Load `parking-keeper-presentation` when domain changes require view contract updates.
- Load `parking-keeper-navigation` when feature logic drives route transitions.

## Domain DoD
- Entities are immutable and include `updated(...)` methods.
- Repository protocols are defined and used by logic structs.
- Domain errors are typed.
- Relevant tests pass.
