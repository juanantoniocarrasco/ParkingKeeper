import SwiftUI
import SwiftData

@main
struct ParkingKeeperApp: App {
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
        }
        .modelContainer(sharedModelContainer)
    }
}
