import SwiftUI
import SwiftData

@main
struct ParkingKeeperApp: App {
    @State private var coordinator = NavigationCoordinator()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ClientPersistentModel.self,
            VehiclePersistentModel.self,
            SpotPersistentModel.self,
            AssignmentPersistentModel.self,
            PaymentPersistentModel.self,
        ])
        let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(coordinator)
        }
        .defaultSize(width: 960, height: 640)
        .modelContainer(sharedModelContainer)
        .commands {
            sidebarCommands()
        }
    }
}

// MARK: - Commands
private extension ParkingKeeperApp {
    @CommandsBuilder
    func sidebarCommands() -> some Commands {
        CommandGroup(replacing: .newItem) {
            Button("Nuevo cliente") {
                coordinator.selectedSidebarItem = .clientList
                coordinator.navigationPath.append(PKScreen.clientForm(nil))
            }
            .keyboardShortcut("n")
        }
        CommandMenu("Ir a") {
            Button("Dashboard") { coordinator.selectedSidebarItem = .dashboard; coordinator.navigationPath = NavigationPath() }
                .keyboardShortcut("1")
            Button("Clientes") { coordinator.selectedSidebarItem = .clientList; coordinator.navigationPath = NavigationPath() }
                .keyboardShortcut("2")
            Button("Vehículos") { coordinator.selectedSidebarItem = .vehicleList; coordinator.navigationPath = NavigationPath() }
                .keyboardShortcut("3")
            Button("Plazas") { coordinator.selectedSidebarItem = .spotGrid; coordinator.navigationPath = NavigationPath() }
                .keyboardShortcut("4")
            Button("Asignaciones") { coordinator.selectedSidebarItem = .assignmentList; coordinator.navigationPath = NavigationPath() }
                .keyboardShortcut("5")
            Button("Pagos") { coordinator.selectedSidebarItem = .paymentList; coordinator.navigationPath = NavigationPath() }
                .keyboardShortcut("6")
            Button("Cuadrante") { coordinator.selectedSidebarItem = .annualGrid; coordinator.navigationPath = NavigationPath() }
                .keyboardShortcut("7")
        }
    }
}
