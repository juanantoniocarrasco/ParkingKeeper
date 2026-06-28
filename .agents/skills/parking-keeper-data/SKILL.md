---
name: parking-keeper-data
description: Data-layer architecture rules for Parking Keeper repositories and SwiftData models. Use when implementing repository/datasource code, SwiftData persistence, mapper boundaries, or model schema changes.
---

# Parking Keeper Data

## Scope
- In scope: SwiftData `@Model` classes, repositories, datasources, mappers at data-domain boundary, persistence integration.
- Out of scope: SwiftUI presentation concerns and app-level navigation orchestration.

## Workflow
1. Inspect existing persistent model and mapper files for conventions.
2. Design repository protocols in the Domain layer first, implement in Data layer.
3. Keep SwiftData persistent model classes isolated to the Data layer.
4. Map between domain entities and persistent models explicitly.
5. Run relevant tests.

## Conventions
- SwiftData models use `@Model final class NamePersistentModel`.
- Persistent model files live in `<Feature>/Data/<Feature>PersistentModel.swift`.
- Repository protocols live in `<Feature>/Domain/<Feature>RepositoryProtocol.swift`.
- Repository implementations live in `<Feature>/Data/<Feature>Repository.swift`.
- Data mappers live in `<Feature>/Data/<Feature>DataMapper.swift` and are pure functions or stateless `enum` types with static methods.
- Use `@Environment(\.modelContext)` for SwiftData access; inject `ModelContext` into repositories.
- Keep persistence concerns out of presentation code and domain contracts.
- Feature folder structure is flat: files are placed directly under `Domain/` and `Data/`, without subdirectories.

## Cross-Skill Triggers
- Load `parking-keeper-domain` when repository changes alter domain error contracts or business rules.
- Load `parking-keeper-presentation` when data changes require view contract updates.
- Load `parking-keeper-navigation` only if data changes introduce or alter routed flows.

## Data DoD
- Repository implements a domain-defined protocol from the Domain layer.
- Persistent models follow `*PersistentModel` naming and schema conventions.
- Data mappers follow `*DataMapper` naming and correctly convert between layers.
- Mapper/repository error boundaries stay explicit.
- Relevant tests pass.
