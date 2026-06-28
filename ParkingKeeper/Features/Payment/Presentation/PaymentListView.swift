import SwiftUI

struct PaymentListView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState = .loaded(PaymentListView.effectiveMocks)

    var body: some View {
        content
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension PaymentListView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                coordinator.navigate(to: PKScreen.paymentForm(nil))
            } label: {
                Label("Nuevo pago", systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    var content: some View {
        switch viewState {
        case .loading:
            loadingView
        case .loaded(let payments):
            loadedList(payments)
        case .empty:
            emptyView
        case .error(let message):
            errorView(message)
        }
    }

    var loadingView: some View {
        ProgressView("Cargando pagos...")
    }

    var emptyView: some View {
        ContentUnavailableView(
            "Sin pagos",
            systemImage: "creditcard.slash",
            description: Text("Registra un pago para empezar.")
        )
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    func loadedList(_ payments: [PaymentRow]) -> some View {
        List(payments) { row in
            NavigationLink(value: PKScreen.receipt(
                Payment(
                    id: row.id,
                    assignmentID: UUID(),
                    amount: row.amount,
                    method: row.method,
                    date: row.date,
                    periodMonths: row.periodMonths,
                    periodStartDate: Date(),
                    periodEndDate: Date()
                )
            )) {
                paymentRow(row)
            }
        }
    }

    func paymentRow(_ row: PaymentRow) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(row.clientName)
                    .font(.headline)
                Spacer()
                Text("\(row.amount.formatted(.currency(code: "EUR")))")
                    .font(.headline)
            }
            HStack {
                Text(row.method == .cash ? "Efectivo" : "Bizum")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(row.date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text("\(row.periodMonths) mes\(row.periodMonths > 1 ? "es" : "")")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - Subtypes
extension PaymentListView {
    struct PaymentRow: Identifiable {
        let id: UUID
        let clientName: String
        let amount: Double
        let method: PaymentMethod
        let date: Date
        let periodMonths: Int
    }

    enum ViewState {
        case loading
        case loaded([PaymentRow])
        case empty
        case error(String)
    }

    static let mocks: [PaymentRow] = [
        .init(id: Payment.mockJanuary.id, clientName: Client.mockMaria.name, amount: Payment.mockJanuary.amount, method: Payment.mockJanuary.method, date: Payment.mockJanuary.date, periodMonths: Payment.mockJanuary.periodMonths),
        .init(id: Payment.mockFebruary.id, clientName: Client.mockMaria.name, amount: Payment.mockFebruary.amount, method: Payment.mockFebruary.method, date: Payment.mockFebruary.date, periodMonths: Payment.mockFebruary.periodMonths),
    ]

    static var effectiveMocks: [PaymentRow] {
        if DemoData.isEnabled {
            return DemoData.payments.map { payment in
                let assignment = DemoData.assignments.first { $0.id == payment.assignmentID }
                let client = assignment.flatMap { a in DemoData.clients.first { $0.id == a.clientID } }
                return PaymentRow(
                    id: payment.id,
                    clientName: client?.name ?? "—",
                    amount: payment.amount,
                    method: payment.method,
                    date: payment.date,
                    periodMonths: payment.periodMonths
                )
            }
        }
        return mocks
    }
}

#Preview("Cargado") {
    NavigationStack {
        PaymentListView()
    }
    .environment(NavigationCoordinator())
}
