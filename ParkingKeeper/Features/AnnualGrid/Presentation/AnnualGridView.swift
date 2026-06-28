import SwiftUI

struct AnnualGridView: View {
    @State private var viewState: ViewState = .loaded(AnnualGridView.mockModel)

    var body: some View {
        content
    }
}

// MARK: - Subviews
private extension AnnualGridView {
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
        ProgressView("Cargando cuadrante...")
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    func loadedView(_ model: Model) -> some View {
        ScrollView([.horizontal, .vertical]) {
            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                headerRow(months: model.months)
                ForEach(model.clients) { client in
                    clientRow(client, months: model.months)
                }
            }
            .padding()
        }
    }

    func headerRow(months: [MonthColumn]) -> some View {
        GridRow {
            Text("Cliente")
                .frame(width: 120, alignment: .leading)
                .bold()
            ForEach(months) { month in
                Text(month.label)
                    .frame(width: 44)
                    .font(.caption)
                    .bold()
            }
        }
    }

    func clientRow(_ client: ClientRow, months: [MonthColumn]) -> some View {
        GridRow {
            Text(client.name)
                .frame(width: 120, alignment: .leading)
                .font(.caption)
                .lineLimit(1)
            ForEach(months) { month in
                let status = client.statusForMonth(month.id)
                Image(systemName: status == .paid ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(status == .paid ? .green : .red)
                    .frame(width: 44)
            }
        }
    }
}

// MARK: - Subtypes
extension AnnualGridView {
    struct Model {
        let clients: [ClientRow]
        let months: [MonthColumn]
    }

    struct ClientRow: Identifiable {
        let id: UUID
        let name: String
        let payments: [ClientPayment]

        func statusForMonth(_ month: Int) -> PaymentStatus {
            payments.contains { $0.month == month && $0.paid } ? .paid : .pending
        }
    }

    struct ClientPayment {
        let month: Int
        let paid: Bool
    }

    struct MonthColumn: Identifiable {
        let id: Int
        let label: String
    }

    enum PaymentStatus {
        case paid
        case pending
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)
    }

    static let mockModel = Model(
        clients: [
            ClientRow(
                id: Client.mockMaria.id,
                name: Client.mockMaria.name,
                payments: [
                    ClientPayment(month: 1, paid: true),
                    ClientPayment(month: 2, paid: true),
                    ClientPayment(month: 3, paid: false),
                ]
            ),
            ClientRow(
                id: Client.mockCarlos.id,
                name: Client.mockCarlos.name,
                payments: [
                    ClientPayment(month: 1, paid: false),
                    ClientPayment(month: 2, paid: false),
                    ClientPayment(month: 3, paid: true),
                ]
            ),
        ],
        months: [
            MonthColumn(id: 1, label: "Ene"),
            MonthColumn(id: 2, label: "Feb"),
            MonthColumn(id: 3, label: "Mar"),
            MonthColumn(id: 4, label: "Abr"),
            MonthColumn(id: 5, label: "May"),
            MonthColumn(id: 6, label: "Jun"),
            MonthColumn(id: 7, label: "Jul"),
            MonthColumn(id: 8, label: "Ago"),
            MonthColumn(id: 9, label: "Sep"),
            MonthColumn(id: 10, label: "Oct"),
            MonthColumn(id: 11, label: "Nov"),
            MonthColumn(id: 12, label: "Dic"),
        ]
    )
}

#Preview("Cargado") {
    AnnualGridView()
}
