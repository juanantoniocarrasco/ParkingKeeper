import SwiftUI

struct ClientListView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState = .loaded(ClientListView.mocks)
    @State private var searchText = ""

    var body: some View {
        content
            .searchable(text: $searchText, prompt: "Search clients")
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension ClientListView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                coordinator.navigationPath.append(PKScreen.clientForm(nil))
            } label: {
                Label("Add Client", systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    var content: some View {
        switch viewState {
        case .loading:
            loadingView
        case .loaded(let clients):
            loadedList(clients)
        case .empty:
            emptyView
        case .error(let message):
            errorView(message)
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

    @ViewBuilder
    func loadedList(_ clients: [ClientListRow]) -> some View {
        let filtered = clients.filtered(by: searchText)
        if filtered.isEmpty {
            ContentUnavailableView.search(text: searchText)
        } else {
            list(filtered)
        }
    }

    func list(_ clients: [ClientListRow]) -> some View {
        List(clients) { row in
            NavigationLink(value: PKScreen.clientDetail(
                Client(id: row.id, name: row.name, phone: row.phone, email: nil, notes: nil)
            )) {
                clientRow(row)
            }
        }
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
    }

    enum ViewState {
        case loading
        case loaded([ClientListRow])
        case empty
        case error(String)
    }
}

// MARK: - Array helpers
private extension [ClientListView.ClientListRow] {
    func filtered(by searchText: String) -> [ClientListView.ClientListRow] {
        guard !searchText.isEmpty else { return self }
        return filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}

// MARK: - Mocks
extension ClientListView {
    static let mocks: [ClientListRow] = [
        .init(id: Client.mockMaria.id, name: Client.mockMaria.name, phone: Client.mockMaria.phone),
        .init(id: Client.mockCarlos.id, name: Client.mockCarlos.name, phone: Client.mockCarlos.phone),
        .init(id: Client.mockAna.id, name: Client.mockAna.name, phone: Client.mockAna.phone),
    ]
}

#Preview("Loaded") {
    NavigationStack {
        ClientListView()
    }
    .environment(NavigationCoordinator())
}
