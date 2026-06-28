import SwiftUI
import SwiftData

@main
struct ParkingKeeperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ClientModel.self,
            VehicleModel.self,
            SpotModel.self,
            AssignmentModel.self,
            PaymentModel.self,
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
