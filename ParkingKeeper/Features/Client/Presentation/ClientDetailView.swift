import SwiftUI

struct ClientDetailView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState

    private let clientID: UUID

    init(clientID: UUID) {
        self.clientID = clientID
        _viewState = State(initialValue: .loaded(ClientDetailView.mockModel))
    }

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                        coordinator.navigationPath.append(
                            PKScreen.clientForm(viewState.client)
                        )
                    }
                }
            }
    }
}

// MARK: - Subviews
private extension ClientDetailView {
    var content: some View {
        switch viewState {
        case .loading:
            return AnyView(loadingView)
        case .loaded(let model):
            return AnyView(loadedView(model))
        case .error(let message):
            return AnyView(errorView(message))
        }
    }

    var loadingView: some View {
        ProgressView("Loading...")
    }

    func loadedView(_ model: Model) -> some View {
        List {
            Section("Contact") {
                LabeledContent("Name", value: model.name)
                if let phone = model.phone {
                    LabeledContent("Phone", value: phone)
                }
                if let email = model.email {
                    LabeledContent("Email", value: email)
                }
            }
            if let notes = model.notes {
                Section("Notes") {
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
        let name: String
        let phone: String?
        let email: String?
        let notes: String?
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)

        var client: Client? {
            if case .loaded(let model) = self {
                return Client(name: model.name, phone: model.phone, email: model.email, notes: model.notes)
            }
            return nil
        }
    }

    static let mockModel = Model(
        name: Client.mockMaria.name,
        phone: Client.mockMaria.phone,
        email: Client.mockMaria.email,
        notes: Client.mockMaria.notes
    )
}

#Preview("Loaded") {
    NavigationStack {
        ClientDetailView(clientID: Client.mockMaria.id)
    }
    .environment(NavigationCoordinator())
}
