import SwiftUI

struct AssignmentFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedClientID: UUID?
    @State private var selectedVehicleID: UUID?
    @State private var selectedSpotID: UUID?
    @State private var monthlyRate: String
    @State private var startDate: Date

    private let formModel: Model?

    private let clientOptions: [AssignmentFormView.ClientOption]
    private let vehicleOptions: [AssignmentFormView.VehicleOption]
    private let spotOptions: [AssignmentFormView.SpotOption]

    init(model: Model?) {
        self.formModel = model
        _selectedClientID = State(initialValue: model?.clientID)
        _selectedVehicleID = State(initialValue: model?.vehicleID)
        _selectedSpotID = State(initialValue: model?.spotID)
        _monthlyRate = State(initialValue: model != nil ? "\(model!.monthlyRate)" : "")
        _startDate = State(initialValue: model?.startDate ?? Date())
        self.clientOptions = AssignmentFormView.mockClients
        self.vehicleOptions = AssignmentFormView.mockVehicles
        self.spotOptions = AssignmentFormView.mockSpots
    }

    var body: some View {
        form
            .navigationTitle(formModel != nil ? "Editar asignación" : "Nueva asignación")
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension AssignmentFormView {
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") { save() }
                    .disabled(!isValid)
            }
        }
    }

    var form: some View {
        Form {
            Section("Cliente") {
                Picker("Cliente", selection: $selectedClientID) {
                    Text("Seleccionar cliente").tag(nil as UUID?)
                    ForEach(clientOptions) { client in
                        Text(client.name).tag(client.id as UUID?)
                    }
                }
            }
            Section("Vehículo") {
                Picker("Matrícula", selection: $selectedVehicleID) {
                    Text("Seleccionar vehículo").tag(nil as UUID?)
                    ForEach(vehicleOptions) { vehicle in
                        Text(vehicle.licensePlate).tag(vehicle.id as UUID?)
                    }
                }
            }
            Section("Plaza") {
                Picker("Plaza", selection: $selectedSpotID) {
                    Text("Seleccionar plaza").tag(nil as UUID?)
                    ForEach(spotOptions) { spot in
                        Text("Plaza \(spot.number)").tag(spot.id as UUID?)
                    }
                }
            }
            Section("Tarifa") {
                TextField("Cuota mensual (€)", text: $monthlyRate)
#if os(iOS)
                    .keyboardType(.decimalPad)
#endif
                DatePicker("Fecha de inicio", selection: $startDate, displayedComponents: .date)
            }
        }
    }
}

// MARK: - Computed
private extension AssignmentFormView {
    var isValid: Bool {
        selectedClientID != nil
            && selectedVehicleID != nil
            && selectedSpotID != nil
            && Double(monthlyRate) != nil
    }
}

// MARK: - Methods
private extension AssignmentFormView {
    func save() {
        dismiss()
    }
}

// MARK: - Subtypes
extension AssignmentFormView {
    struct Model {
        let id: UUID
        let clientID: UUID?
        let vehicleID: UUID?
        let spotID: UUID?
        let startDate: Date
        let monthlyRate: Double
    }

    struct ClientOption: Identifiable {
        let id: UUID
        let name: String
    }

    struct VehicleOption: Identifiable {
        let id: UUID
        let licensePlate: String
    }

    struct SpotOption: Identifiable {
        let id: UUID
        let number: Int
    }

    static let mockClients: [ClientOption] = [
        ClientOption(id: Client.mockMaria.id, name: Client.mockMaria.name),
        ClientOption(id: Client.mockCarlos.id, name: Client.mockCarlos.name),
        ClientOption(id: Client.mockAna.id, name: Client.mockAna.name),
    ]

    static let mockVehicles: [VehicleOption] = [
        VehicleOption(id: Vehicle.mockSeatLeon.id, licensePlate: Vehicle.mockSeatLeon.licensePlate),
        VehicleOption(id: Vehicle.mockRenault.id, licensePlate: Vehicle.mockRenault.licensePlate),
        VehicleOption(id: Vehicle.mockToyota.id, licensePlate: Vehicle.mockToyota.licensePlate),
    ]

    static let mockSpots: [SpotOption] = [
        SpotOption(id: Spot.mockSpot1.id, number: 1),
        SpotOption(id: Spot.mockSpot2.id, number: 2),
        SpotOption(id: Spot.mockSpot3.id, number: 3),
    ]

    static func mockNew() -> Model {
        Model(id: UUID(), clientID: nil, vehicleID: nil, spotID: nil, startDate: Date(), monthlyRate: 0)
    }

    static func mockEdit() -> Model {
        Model(
            id: Assignment.mockActive.id,
            clientID: Client.mockMaria.id,
            vehicleID: Vehicle.mockSeatLeon.id,
            spotID: Spot.mockSpot2.id,
            startDate: Assignment.mockActive.startDate,
            monthlyRate: Assignment.mockActive.monthlyRate
        )
    }
}

#Preview("Nueva asignación") {
    AssignmentFormView(model: AssignmentFormView.mockNew())
}

#Preview("Editar asignación") {
    AssignmentFormView(model: AssignmentFormView.mockEdit())
}
