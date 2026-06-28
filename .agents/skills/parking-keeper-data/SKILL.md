---
name: parking-keeper-data
description: Data-layer architecture rules for Parking Keeper repositories and SwiftData models. Use when implementing repository/datasource code, SwiftData persistence, mapper boundaries, or model schema changes.
---

# Parking Keeper Data

## Scope
- In scope: SwiftData `@Model` classes, repositories, datasources, mappers at data-domain boundary, persistence integration.
- Out of scope: SwiftUI presentation concerns and app-level navigation orchestration.

## Workflow
1. Inspect nearby repository/model files for local conventions.
2. Design repository protocols in the Domain layer first, implement in Data layer.
3. Keep SwiftData `@Model` classes isolated to the Data layer when possible.
4. Map between domain entities and SwiftData models explicitly.
5. Run relevant tests.

## Conventions
- SwiftData models use `@Model final class ModelName`.
- Repository protocols live in `<Feature>/Domain/Repositories/`.
- Repository implementations (adapters) live in `<Feature>/Data/Repositories/`.
- Mappers live in `<Feature>/Data/Mappers/` and are pure functions or stateless types.
- Use `@Environment(\.modelContext)` for SwiftData access; inject `ModelContext` into repositories.
- Keep persistence concerns out of presentation code and domain contracts.

## Cross-Skill Triggers
- Load `parking-keeper-domain` when repository changes alter domain error contracts or business rules.
- Load `parking-keeper-presentation` when data changes require view contract updates.
- Load `parking-keeper-navigation` only if data changes introduce or alter routed flows.

## Data DoD
- Repository implements a domain-defined protocol from the Domain layer.
- SwiftData models follow schema conventions and relationships are correctly defined.
- Mapper/repository error boundaries stay explicit.
- Relevant tests pass.
