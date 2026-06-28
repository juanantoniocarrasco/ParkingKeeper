# Parking Keeper — Development Roadmap

## Instructions for Agents

- **Read this file at the start of every conversation.**
- Update `[ ]` → `[x]` as tasks are completed within a conversation.
- Commit progress with conventional commits (`feat:`, `fix:`, `chore:`, etc.).
- Do not start work outside the current phase unless explicitly asked.
- If a phase is partially done, add sub-checkboxes or notes rather than removing tasks.

---

## Project Context

```
App: ParkingKeeper
Platform: iOS 18+ / macOS 15+ (multiplataforma, un solo target)
Repo: github.com/juanantoniocarrasco/ParkingKeeper (público)
Local path: ~/Developer/Personal_gitHub/ParkingKeeper

Stack: SwiftUI, SwiftData + CloudKit (iCloud sync), @Observable, NavigationStack, SPM.
No CocoaPods. No SwiftLint.

Arquitectura: Features/<Feature>/Presentation | Domain | Data | Composition.
- Views gestionan su propia lógica de presentación con @State + helpers.
- @Observable ViewModels solo para estado compartido entre 2+ vistas.
- Cada entidad tiene su FeatureLogic struct con funciones de negocio.
- Repository protocols en Domain, implementación SwiftData en Data.
- Assemblers en Composition cablean dependencias.

Dominio:
- Client: name, phone, email, vehicles[], notes
- Vehicle: licensePlate, brand, model
- Spot: number, status (free/occupied)
- Assignment: client + vehicle + spot, startDate, endDate?, monthlyRate
- Payment: assignment, amount, method (cash/bizum), date, months period (1..N)
- Receipt: derivado del Payment (vista/PDF)
- Sin Invoice (el recibo se genera al pagar, no hay facturación periódica automática)

Clientes históricos: se mantienen vía Assignment.endDate.
Tarifas: por Assignment (no global). Un cliente puede tener N plazas.

Commits: Conventional Commits.
Contexto de negocio concreto (precios, reglas operativas) NO se commitea (repo público).

Skills: .agents/skills/ (parking-keeper-presentation, -navigation, -data, -domain, grill-me).
```

---

## Fase 0: Configuración inicial

- [x] Limpiar template Xcode (borrar `Item.swift`, reescribir `ContentView.swift`)
- [x] Crear estructura de carpetas: `Core/`, `Features/`
- [x] Activar CloudKit en Signing & Capabilities del target
- [x] Configurar `ModelConfiguration` con iCloud container

## Fase 1: Modelo de datos

- [x] SwiftData @Model: `ClientModel`, `VehicleModel`, `SpotModel`, `AssignmentModel`, `PaymentModel`
- [x] Domain entities: `Client`, `Vehicle`, `Spot`, `Assignment`, `Payment`
- [x] Repository protocols: `ClientRepositoryProtocol`, `VehicleRepositoryProtocol`, etc.
- [x] SwiftData repository implementations
- [x] Mappers: Model ↔ Entity
- [ ] Unit tests de modelos y repos

## Fase 2: Navegación

- [ ] `Core/Navigation/AppRootView.swift` — NavigationSplitView root
- [ ] `Core/Navigation/PKScreen.swift` — enum tipado de pantallas
- [ ] `Core/Navigation/NavigationCoordinator.swift` — @Observable coordinator
- [ ] Assembler de navegación

## Fase 3: Features core

- [ ] Dashboard (resumen: plazas ocupadas, pagos pendientes del mes)
- [ ] Clients (list, detail, form, search)
- [ ] Vehicles (list, form)
- [ ] Spots (vista de parcela con estado libre/ocupada)

## Fase 4: Features de operación

- [ ] Assignments (asignar cliente+vehículo a plaza, dar de baja, históricos)
- [ ] Payments (registrar pago N meses, cash/bizum, vista de historial)
- [ ] Cuadrante anual (clientes × meses, indicador pagado/pendiente)

## Fase 5: Recibos & sincronización

- [ ] Receipt (vista/PDF/share derivada de Payment)
- [ ] Verificar CloudKit sync entre iOS y macOS
- [ ] Adaptaciones UI para macOS

## Fase 6: Pulido

- [ ] PK Design System (colores, spacing, fonts, componentes base)
- [ ] Localización (es / en)
- [ ] UI tests
- [ ] App Store / release

---

## Phase Log

| Fase | Completada | Commit |
|------|-----------|--------|
| 0 | ✓ | `b6412bb` |
| 1 | — | — |
| 2 | — | — |
| 3 | — | — |
| 4 | — | — |
| 5 | — | — |
| 6 | — | — |
