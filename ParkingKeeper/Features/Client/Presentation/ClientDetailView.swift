import SwiftUI

struct ClientDetailView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState

    private let clientID: UUID

    init(clientID: UUID) {
        self.clientID = clientID
        _viewState = State(initialValue: .loaded(ClientDetailView.effectiveModel(for: clientID)))
    }

    var body: some View {
        content
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension ClientDetailView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if case .loaded(let model) = viewState {
                Button("Editar") {
                    coordinator.navigate(to: 
                        PKScreen.clientForm(Client(
                            id: model.id,
                            name: model.name,
                            phone: model.phone,
                            email: model.email,
                            notes: model.notes
                        ))
                    )
                }
            }
        }
    }

    @ViewBuilder
    var content: some View {
        switch viewState {
        case .loading:
            loadingView
        case .loaded(let model):
            loadedView(model)
        case .error(let message):
            errorView(message)
        }
    }

    var loadingView: some View {
        ProgressView("Cargando...")
    }

    func loadedView(_ model: Model) -> some View {
        List {
            Section("Contacto") {
                LabeledContent("Nombre", value: model.name)
                if let phone = model.phone {
                    LabeledContent("Teléfono", value: phone)
                }
                if let email = model.email {
                    LabeledContent("Correo", value: email)
                }
            }
            if !model.vehicles.isEmpty {
                Section("Vehículos") {
                    ForEach(model.vehicles) { vehicle in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(vehicle.licensePlate)
                                .font(.headline)
                            if let description = vehicle.description {
                                Text(description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            if let notes = model.notes {
                Section("Notas") {
                    Text(notes)
                }
            }
        }
        .navigationTitle(model.name)
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }
}

// MARK: - Subtypes
extension ClientDetailView {
    struct Model {
        let id: UUID
        let name: String
        let phone: String?
        let email: String?
        let notes: String?
        let vehicles: [VehicleItem]
    }

    struct VehicleItem: Identifiable {
        let id: UUID
        let licensePlate: String
        let description: String?
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)
    }

    static let mockModel = Model(
        id: Client.mockMaria.id,
        name: Client.mockMaria.name,
        phone: Client.mockMaria.phone,
        email: Client.mockMaria.email,
        notes: Client.mockMaria.notes,
        vehicles: [
            VehicleItem(id: Vehicle.mockSeatLeon.id, licensePlate: Vehicle.mockSeatLeon.licensePlate, description: "Seat Leon"),
            VehicleItem(id: Vehicle.mockRenault.id, licensePlate: Vehicle.mockRenault.licensePlate, description: "Renault Clio"),
        ]
    )

    static func effectiveModel(for clientID: UUID) -> Model {
        if DemoData.isEnabled, let client = DemoData.clients.first(where: { $0.id == clientID }) {
            let vehicles = DemoData.vehicles.filter { $0.clientID == clientID }.map {
                VehicleItem(id: $0.id, licensePlate: $0.licensePlate, description: [$0.brand, $0.model].compactMap { $0 }.joined(separator: " "))
            }
            return Model(
                id: client.id,
                name: client.name,
                phone: client.phone,
                email: client.email,
                notes: client.notes,
                vehicles: vehicles
            )
        }
        return mockModel
    }
}

#Preview("Cargado") {
    NavigationStack {
        ClientDetailView(clientID: Client.mockMaria.id)
    }
    .environment(NavigationCoordinator())
}
