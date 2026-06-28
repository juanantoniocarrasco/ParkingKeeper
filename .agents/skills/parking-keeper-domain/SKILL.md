---
name: parking-keeper-domain
description: Domain logic rules for Parking Keeper. Use when implementing or refactoring business logic, use cases, domain error mapping, and domain-focused test coverage.
---

# Parking Keeper Domain

## Scope
- In scope: business rules, deterministic domain transforms, domain error contracts, use cases.
- Out of scope: SwiftUI layout/styling and persistence wiring details.

## Domain

Parking Keeper manages a parking business with these core domain concepts:

- **Client**: name, phone, email, associated vehicles, notes.
- **Vehicle**: license plate, brand, model, owner (Client).
- **Spot**: parking space identified by number, status (free/occupied).
- **Assignment**: links a Client, Vehicle, and Spot. Has `startDate`, `endDate` (optional, for historical tracking when a client leaves), and `monthlyRate` (per-client rate, not global).
- **Payment**: records a payment for an Assignment. Covers 1..N months (advance, on-time, or late). Has `amount`, `method` (cash/bizum), `date`, and a `months` period. The receipt is derived from the Payment record.
- No periodic automatic billing — Payments are recorded when the client actually pays.

## Feature Logic

Each entity has a dedicated `Logic` struct that holds all business functions for that entity. Views receive the `Logic` via initializer.

```swift
struct ClientLogic {
    private let clientRepository: any ClientRepositoryProtocol
    private let paymentRepository: any PaymentRepositoryProtocol

    func validate(_ client: Client) throws { ... }
    func monthsCovered(for client: Client) -> [MonthYear] { ... }
    func hasOutstandingMonths(for client: Client, asOf: Date) -> [MonthYear] { ... }
}

struct AssignmentLogic {
    private let repository: any AssignmentRepositoryProtocol

    func isActive(_ assignment: Assignment) -> Bool { ... }
    func isHistorical(_ assignment: Assignment) -> Bool { ... }
}
```

## Conventions
- Domain entities are value types (`struct`) unless identity is essential (`Hashable`/`Identifiable`).
- Each entity gets a `FeatureLogic` struct (e.g., `ClientLogic`, `SpotLogic`) with all domain functions for that entity.
- Logic structs receive repository protocols and other dependencies via initializer.
- Domain errors are typed enums conforming to `Error`.
- Business rules stay UI-agnostic and deterministic.
- All domain logic must be testable without SwiftData or SwiftUI imports.

## Workflow
1. Inspect nearby domain/logic files to match local architecture.
2. Design entities and logic structs before wiring to Data or Presentation.
3. Add or update focused domain tests.
4. Run relevant tests.

## Cross-Skill Triggers
- Load `parking-keeper-data` when domain contracts require repository or mapper changes.
- Load `parking-keeper-presentation` when domain model changes affect view input contracts.
- Load `parking-keeper-navigation` when domain outcomes drive navigation state transitions.

## Domain DoD
- Responsibilities are split by domain concern.
- Domain logic remains UI-agnostic and deterministic.
- Error mapping boundaries are explicit and consistent.
- Tests cover normal flows and required edge cases.
- Regression tests are added for fixed domain bugs.
- Relevant tests pass.
