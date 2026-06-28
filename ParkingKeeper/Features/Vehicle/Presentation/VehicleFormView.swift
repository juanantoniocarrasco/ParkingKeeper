import SwiftUI

struct VehicleFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var licensePlate: String
    @State private var brand: String
    @State private var model: String

    private let formModel: Model?

    init(model: Model?) {
        self.formModel = model
        _licensePlate = State(initialValue: model?.licensePlate ?? "")
        _brand = State(initialValue: model?.brand ?? "")
        _model = State(initialValue: model?.model ?? "")
    }

    var body: some View {
        form
            .navigationTitle(formModel != nil ? "Edit Vehicle" : "New Vehicle")
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension VehicleFormView {
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(licensePlate.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    var form: some View {
        Form {
            Section("Vehicle Information") {
                TextField("License Plate", text: $licensePlate)
                    .textContentType(.none)
                TextField("Brand", text: $brand)
                TextField("Model", text: $model)
            }
        }
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
    }

    static func mockNew() -> Model {
        Model(id: UUID(), licensePlate: nil, brand: nil, model: nil)
    }

    static func mockEdit() -> Model {
        Model(
            id: Vehicle.mockSeatLeon.id,
            licensePlate: Vehicle.mockSeatLeon.licensePlate,
            brand: Vehicle.mockSeatLeon.brand,
            model: Vehicle.mockSeatLeon.model
        )
    }
}

#Preview("New Vehicle") {
    VehicleFormView(model: VehicleFormView.mockNew())
}

#Preview("Edit Vehicle") {
    VehicleFormView(model: VehicleFormView.mockEdit())
}
