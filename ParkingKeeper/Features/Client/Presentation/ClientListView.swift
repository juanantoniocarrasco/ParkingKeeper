import SwiftUI

struct ClientListView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState = .loaded(ClientListView.mocks)
    @State private var searchText = ""

    var body: some View {
        content
            .searchable(text: $searchText, prompt: "Search clients")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        coordinator.navigationPath.append(PKScreen.clientForm(nil))
                    } label: {
                        Label("Add Client", systemImage: "plus")
                    }
                }
            }
    }
}

// MARK: - Subviews
private extension ClientListView {
    var content: some View {
        switch viewState {
        case .loading:
            return AnyView(loadingView)
        case .loaded(let clients):
            return AnyView(clientList(clients))
        case .empty:
            return AnyView(emptyView)
        case .error(let message):
            return AnyView(errorView(message))
        }
    }

    var loadingView: some View {
        ProgressView("Loading clients...")
    }

    var emptyView: some View {
        ContentUnavailableView(
            "No Clients",
            systemImage: "person.2.slash",
            description: Text("Add a client to get started.")
        )
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    func clientList(_ clients: [ClientListRow]) -> some View {
        let filtered = clients.filtered(by: searchText)
        return Group {
            if filtered.isEmpty {
                emptySearchView
            } else {
                List(filtered) { row in
                    NavigationLink(value: PKScreen.clientDetail(
                        row.domainClient
                    )) {
                        clientRow(row)
                    }
                }
            }
        }
    }

    var emptySearchView: some View {
        ContentUnavailableView.search(text: searchText)
    }

    func clientRow(_ row: ClientListRow) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(row.name)
                .font(.headline)
            if let phone = row.phone {
                Text(phone)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Subtypes
extension ClientListView {
    struct ClientListRow: Identifiable {
        let id: UUID
        let name: String
        let phone: String?
        let domainClient: Client

        func filtered(by searchText: String) -> Bool {
            guard !searchText.isEmpty else { return true }
            return name.localizedCaseInsensitiveContains(searchText)
        }
    }

    enum ViewState {
        case loading
        case loaded([ClientListRow])
        case empty
        case error(String)
    }
}

extension [ClientListView.ClientListRow] {
    func filtered(by searchText: String) -> [ClientListView.ClientListRow] {
        guard !searchText.isEmpty else { return self }
        return filter { $0.filtered(by: searchText) }
    }
}

// MARK: - Mocks
extension ClientListView {
    static let mocks: [ClientListRow] = [
        .init(id: Client.mockMaria.id, name: Client.mockMaria.name, phone: Client.mockMaria.phone, domainClient: Client.mockMaria),
        .init(id: Client.mockCarlos.id, name: Client.mockCarlos.name, phone: Client.mockCarlos.phone, domainClient: Client.mockCarlos),
        .init(id: Client.mockAna.id, name: Client.mockAna.name, phone: Client.mockAna.phone, domainClient: Client.mockAna),
    ]
}

#Preview("Loaded") {
    NavigationStack {
        ClientListView()
    }
    .environment(NavigationCoordinator())
}
