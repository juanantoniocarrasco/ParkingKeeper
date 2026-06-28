import SwiftUI

struct ClientFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var phone: String
    @State private var email: String
    @State private var notes: String

    private let client: Client?

    init(client: Client?) {
        self.client = client
        _name = State(initialValue: client?.name ?? "")
        _phone = State(initialValue: client?.phone ?? "")
        _email = State(initialValue: client?.email ?? "")
        _notes = State(initialValue: client?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            form
                .navigationTitle(client != nil ? "Edit Client" : "New Client")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { save() }
                            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
        }
    }
}

// MARK: - Subviews
private extension ClientFormView {
    var form: some View {
        Form {
            Section("Client Information") {
                TextField("Name", text: $name)
                    .textContentType(.name)
                TextField("Phone", text: $phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            }
            Section("Notes") {
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

#Preview("New Client") {
    ClientFormView(client: nil)
}

#Preview("Edit Client") {
    ClientFormView(client: Client.mockMaria)
}
