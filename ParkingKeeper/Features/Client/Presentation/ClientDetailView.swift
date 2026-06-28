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
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension ClientDetailView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if case .loaded(let model) = viewState {
                Button("Edit") {
                    coordinator.navigationPath.append(
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
        let id: UUID
        let name: String
        let phone: String?
        let email: String?
        let notes: String?
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
        notes: Client.mockMaria.notes
    )
}

#Preview("Loaded") {
    NavigationStack {
        ClientDetailView(clientID: Client.mockMaria.id)
    }
    .environment(NavigationCoordinator())
}
