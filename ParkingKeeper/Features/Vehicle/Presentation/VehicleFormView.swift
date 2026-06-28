import SwiftUI

struct VehicleFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var licensePlate: String
    @State private var brand: String
    @State private var model: String
    @State private var selectedClientID: UUID?

    private let formModel: Model?

    init(model: Model?) {
        self.formModel = model
        _licensePlate = State(initialValue: model?.licensePlate ?? "")
        _brand = State(initialValue: model?.brand ?? "")
        _model = State(initialValue: model?.model ?? "")
        _selectedClientID = State(initialValue: model?.clientID)
    }

    var body: some View {
        form
            .navigationTitle(formModel != nil ? "Editar vehículo" : "Nuevo vehículo")
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension VehicleFormView {
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
            Section("Información del vehículo") {
                TextField("Matrícula", text: $licensePlate)
                    .textContentType(.none)
                TextField("Marca", text: $brand)
                TextField("Modelo", text: $model)
            }
            Section("Cliente") {
                clientPicker
            }
        }
    }

    var clientPicker: some View {
        Picker("Cliente", selection: $selectedClientID) {
            Text("Seleccionar cliente").tag(nil as UUID?)
            ForEach(VehicleFormView.clientOptions) { client in
                Text(client.name).tag(client.id as UUID?)
            }
        }
    }
}

// MARK: - Computed
private extension VehicleFormView {
    var isValid: Bool {
        !licensePlate.trimmingCharacters(in: .whitespaces).isEmpty
            && selectedClientID != nil
    }
}

// MARK: - Methods
private extension VehicleFormView {
    func save() {
        dismiss()
    }
}

// MARK: - Subtypes
extension VehicleFormView {
    struct Model {
        let id: UUID
        let licensePlate: String?
        let brand: String?
        let model: String?
        let clientID: UUID?
    }

    struct ClientOption: Identifiable {
        let id: UUID
        let name: String
    }

    static let clientOptions: [ClientOption] = [
        ClientOption(id: Client.mockMaria.id, name: Client.mockMaria.name),
        ClientOption(id: Client.mockCarlos.id, name: Client.mockCarlos.name),
        ClientOption(id: Client.mockAna.id, name: Client.mockAna.name),
    ]

    static func mockNew() -> Model {
        Model(id: UUID(), licensePlate: nil, brand: nil, model: nil, clientID: nil)
    }

    static func mockEdit() -> Model {
        Model(
            id: Vehicle.mockSeatLeon.id,
            licensePlate: Vehicle.mockSeatLeon.licensePlate,
            brand: Vehicle.mockSeatLeon.brand,
            model: Vehicle.mockSeatLeon.model,
            clientID: Client.mockMaria.id
        )
    }
}

#Preview("Nuevo vehículo") {
    VehicleFormView(model: VehicleFormView.mockNew())
}

#Preview("Editar vehículo") {
    VehicleFormView(model: VehicleFormView.mockEdit())
}
