import SwiftUI

struct AnnualGridView: View {
    @State private var viewState: ViewState = .loaded(AnnualGridView.mockModel)

    private let currentMonth: Int = Calendar.current.component(.month, from: Date())

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
                ForEach(Array(model.clients.enumerated()), id: \.element.id) { index, client in
                    clientRow(client, index: index + 1, months: model.months)
                }
            }
            .padding()
        }
    }

    func headerRow(months: [MonthColumn]) -> some View {
        GridRow {
            Text("Cliente")
                .frame(width: 180, alignment: .leading)
                .bold()
            ForEach(months) { month in
                Text(month.label)
                    .frame(width: 44)
                    .font(.caption)
                    .bold()
            }
        }
    }

    func clientRow(_ client: ClientRow, index: Int, months: [MonthColumn]) -> some View {
        GridRow {
            Text("\(index). \(client.name)")
                .frame(width: 180, alignment: .leading)
                .font(.caption)
                .lineLimit(1)
            ForEach(months) { month in
                cellView(for: client.statusForMonth(month.id, currentMonth: currentMonth))
            }
        }
    }

    @ViewBuilder
    func cellView(for status: PaymentStatus) -> some View {
        switch status {
        case .paid:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .frame(width: 44)
        case .pending:
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
                .frame(width: 44)
        case .future, .noAssignment:
            Text("·")
                .foregroundStyle(.tertiary)
                .frame(width: 44)
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
        let firstMonth: Int?
        let paidUpToMonth: Int?

        func statusForMonth(_ month: Int, currentMonth: Int) -> PaymentStatus {
            guard let first = firstMonth else { return .noAssignment }
            if month < first { return .noAssignment }
            if month > currentMonth { return .future }
            if let paid = paidUpToMonth, month <= paid { return .paid }
            return .pending
        }
    }

    struct MonthColumn: Identifiable {
        let id: Int
        let label: String
    }

    enum PaymentStatus {
        case paid
        case pending
        case future
        case noAssignment
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)
    }

    static let mockModel = Model(
        clients: [
            ClientRow(id: Client.mockMaria.id, name: Client.mockMaria.name, firstMonth: 1, paidUpToMonth: 6),
            ClientRow(id: Client.mockCarlos.id, name: Client.mockCarlos.name, firstMonth: 1, paidUpToMonth: 4),
            ClientRow(id: Client.mockAna.id, name: Client.mockAna.name, firstMonth: 1, paidUpToMonth: 5),
            ClientRow(id: UUID(), name: "Miguel Fernández", firstMonth: 1, paidUpToMonth: 3),
            ClientRow(id: UUID(), name: "Lucía Romero", firstMonth: 1, paidUpToMonth: 6),
            ClientRow(id: UUID(), name: "Javier Torres", firstMonth: 2, paidUpToMonth: 5),
            ClientRow(id: UUID(), name: "Elena Castro", firstMonth: 3, paidUpToMonth: 4),
            ClientRow(id: UUID(), name: "Pablo Núñez", firstMonth: 1, paidUpToMonth: 2),
            ClientRow(id: UUID(), name: "Sara Delgado", firstMonth: 1, paidUpToMonth: 6),
            ClientRow(id: UUID(), name: "David Herrera", firstMonth: 1, paidUpToMonth: nil),
        ],
        months: [
            MonthColumn(id: 1, label: "Ene"), MonthColumn(id: 2, label: "Feb"),
            MonthColumn(id: 3, label: "Mar"), MonthColumn(id: 4, label: "Abr"),
            MonthColumn(id: 5, label: "May"), MonthColumn(id: 6, label: "Jun"),
            MonthColumn(id: 7, label: "Jul"), MonthColumn(id: 8, label: "Ago"),
            MonthColumn(id: 9, label: "Sep"), MonthColumn(id: 10, label: "Oct"),
            MonthColumn(id: 11, label: "Nov"), MonthColumn(id: 12, label: "Dic"),
        ]
    )
}

#Preview("Cargado") {
    AnnualGridView()
}
