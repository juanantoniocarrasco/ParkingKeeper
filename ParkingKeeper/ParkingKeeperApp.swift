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
            appCommands()
        }
    }
}

// MARK: - Commands
private extension ParkingKeeperApp {
    @CommandsBuilder
    func appCommands() -> some Commands {
        CommandGroup(replacing: .newItem) {
            Button("Nuevo cliente") {
                coordinator.selectedTab = .clients
                coordinator.clientsPath = NavigationPath()
                coordinator.clientsPath.append(PKScreen.clientForm(nil))
            }
            .keyboardShortcut("n")
        }
        CommandMenu("Ir a") {
            Button("Dashboard") { coordinator.selectedTab = .dashboard }
                .keyboardShortcut("1")
            Button("Clientes") { coordinator.selectedTab = .clients }
                .keyboardShortcut("2")
            Button("Plazas") { coordinator.selectedTab = .spots }
                .keyboardShortcut("3")
            Button("Pagos") { coordinator.selectedTab = .payments }
                .keyboardShortcut("4")
        }
    }
}
