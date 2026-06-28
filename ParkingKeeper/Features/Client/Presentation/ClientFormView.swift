import SwiftUI

struct ClientFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var phone: String
    @State private var email: String
    @State private var notes: String

    private let model: Model?

    init(model: Model?) {
        self.model = model
        _name = State(initialValue: model?.name ?? "")
        _phone = State(initialValue: model?.phone ?? "")
        _email = State(initialValue: model?.email ?? "")
        _notes = State(initialValue: model?.notes ?? "")
    }

    var body: some View {
        form
            .navigationTitle(model != nil ? "Editar cliente" : "Nuevo cliente")
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension ClientFormView {
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") { save() }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    var form: some View {
        Form {
            Section("Información del cliente") {
                TextField("Nombre", text: $name)
                    .textContentType(.name)
                TextField("Teléfono", text: $phone)
                    .textContentType(.telephoneNumber)
#if os(iOS)
                    .keyboardType(.phonePad)
#endif
                TextField("Correo", text: $email)
                    .textContentType(.emailAddress)
#if os(iOS)
                    .keyboardType(.emailAddress)
#endif
            }
            Section("Notas") {
                TextEditor(text: $notes)
                    .frame(minHeight: 80)
            }
        }
    }
}

// MARK: - Methods
private extension ClientFormView {
    func save() {
        dismiss()
    }
}

// MARK: - Subtypes
extension ClientFormView {
    struct Model {
        let id: UUID
        let name: String?
        let phone: String?
        let email: String?
        let notes: String?
    }

    static func mockNew() -> Model {
        Model(id: UUID(), name: nil, phone: nil, email: nil, notes: nil)
    }

    static func mockEdit() -> Model {
        Model(
            id: Client.mockMaria.id,
            name: Client.mockMaria.name,
            phone: Client.mockMaria.phone,
            email: Client.mockMaria.email,
            notes: Client.mockMaria.notes
        )
    }
}

#Preview("Nuevo cliente") {
    ClientFormView(model: ClientFormView.mockNew())
}

#Preview("Editar cliente") {
    ClientFormView(model: ClientFormView.mockEdit())
}
