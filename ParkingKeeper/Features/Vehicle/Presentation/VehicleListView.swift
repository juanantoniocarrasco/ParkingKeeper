import SwiftUI

struct VehicleListView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState = .loaded(VehicleListView.mocks)
    @State private var searchText = ""

    var body: some View {
        content
            .searchable(text: $searchText, prompt: "Search vehicles")
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension VehicleListView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                coordinator.navigationPath.append(PKScreen.vehicleForm(nil))
            } label: {
                Label("Add Vehicle", systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    var content: some View {
        switch viewState {
        case .loading:
            loadingView
        case .loaded(let vehicles):
            loadedList(vehicles)
        case .empty:
            emptyView
        case .error(let message):
            errorView(message)
        }
    }

    var loadingView: some View {
        ProgressView("Loading vehicles...")
    }

    var emptyView: some View {
        ContentUnavailableView(
            "No Vehicles",
            systemImage: "car.slash",
            description: Text("Add a vehicle to get started.")
        )
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    @ViewBuilder
    func loadedList(_ vehicles: [VehicleListRow]) -> some View {
        let filtered = vehicles.filtered(by: searchText)
        if filtered.isEmpty {
            ContentUnavailableView.search(text: searchText)
        } else {
            list(filtered)
        }
    }

    func list(_ vehicles: [VehicleListRow]) -> some View {
        List(vehicles) { row in
            vehicleRow(row)
        }
    }

    func vehicleRow(_ row: VehicleListRow) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(row.licensePlate)
                .font(.headline)
            if let description = row.description {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Subtypes
extension VehicleListView {
    struct VehicleListRow: Identifiable {
        let id: UUID
        let licensePlate: String
        let description: String?
    }

    enum ViewState {
        case loading
        case loaded([VehicleListRow])
        case empty
        case error(String)
    }
}

// MARK: - Array helpers
private extension [VehicleListView.VehicleListRow] {
    func filtered(by searchText: String) -> [VehicleListView.VehicleListRow] {
        guard !searchText.isEmpty else { return self }
        return filter { row in
            row.licensePlate.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Mocks
extension VehicleListView {
    static let mocks: [VehicleListRow] = [
        .init(id: Vehicle.mockSeatLeon.id, licensePlate: Vehicle.mockSeatLeon.licensePlate, description: "Seat Leon"),
        .init(id: Vehicle.mockRenault.id, licensePlate: Vehicle.mockRenault.licensePlate, description: "Renault Clio"),
        .init(id: Vehicle.mockToyota.id, licensePlate: Vehicle.mockToyota.licensePlate, description: "Toyota Corolla"),
    ]
}

#Preview("Loaded") {
    NavigationStack {
        VehicleListView()
    }
    .environment(NavigationCoordinator())
}
