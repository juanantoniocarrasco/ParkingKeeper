import SwiftUI

struct ReceiptView: View {
    @State private var viewState: ViewState

    private let paymentID: UUID

    init(paymentID: UUID) {
        self.paymentID = paymentID
        _viewState = State(initialValue: .loaded(ReceiptView.mockModel))
    }

    var body: some View {
        content
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension ReceiptView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if case .loaded(let model) = viewState {
                ShareLink(item: receiptText(model), preview: SharePreview("Recibo", image: Image(systemName: "doc.text")))
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
        ProgressView("Cargando...")
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    func loadedView(_ model: Model) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                receiptHeader(model)
                Divider()
                receiptBody(model)
                Divider()
                receiptFooter(model)
            }
            .padding()
        }
    }

    func receiptHeader(_ model: Model) -> some View {
        VStack(spacing: 4) {
            Text("Parking Keeper")
                .font(.title)
                .bold()
            Text("Recibo de pago")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Nº \(model.paymentID.uuidString.prefix(8))")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    func receiptBody(_ model: Model) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            row(label: "Cliente", value: model.clientName)
            row(label: "Vehículo", value: model.licensePlate)
            row(label: "Plaza", value: "\(model.spotNumber)")
            Divider()
            row(label: "Importe", value: "\(model.amount.formatted(.currency(code: "EUR")))")
            row(label: "Método", value: model.method == .cash ? "Efectivo" : "Bizum")
            row(label: "Período", value: periodLabel(model))
            row(label: "Fecha de pago", value: model.date.formatted(date: .long, time: .omitted))
        }
    }

    func receiptFooter(_ model: Model) -> some View {
        VStack(spacing: 4) {
            Text("Gracias por su pago")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(Date().formatted(date: .long, time: .shortened))
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }

    func row(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.body)
            Spacer()
        }
    }

    func periodLabel(_ model: Model) -> String {
        let start = model.periodStartDate.formatted(date: .abbreviated, time: .omitted)
        let end = model.periodEndDate.formatted(date: .abbreviated, time: .omitted)
        return "\(start) – \(end) (\(model.periodMonths) mes\(model.periodMonths > 1 ? "es" : ""))"
    }

    func receiptText(_ model: Model) -> String {
        """
        Parking Keeper — Recibo de pago
        Nº \(model.paymentID.uuidString.prefix(8))

        Cliente: \(model.clientName)
        Vehículo: \(model.licensePlate)
        Plaza: \(model.spotNumber)

        Importe: \(model.amount.formatted(.currency(code: "EUR")))
        Método: \(model.method == .cash ? "Efectivo" : "Bizum")
        Período: \(periodLabel(model))
        Fecha de pago: \(model.date.formatted(date: .long, time: .omitted))

        Gracias por su pago.
        Emitido: \(Date().formatted(date: .long, time: .shortened))
        """
    }
}

// MARK: - Subtypes
extension ReceiptView {
    struct Model {
        let paymentID: UUID
        let clientName: String
        let licensePlate: String
        let spotNumber: Int
        let amount: Double
        let method: PaymentMethod
        let date: Date
        let periodMonths: Int
        let periodStartDate: Date
        let periodEndDate: Date
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)
    }

    static let mockModel = Model(
        paymentID: Payment.mockJanuary.id,
        clientName: Client.mockMaria.name,
        licensePlate: Vehicle.mockSeatLeon.licensePlate,
        spotNumber: Spot.mockSpot2.number,
        amount: Payment.mockJanuary.amount,
        method: Payment.mockJanuary.method,
        date: Payment.mockJanuary.date,
        periodMonths: Payment.mockJanuary.periodMonths,
        periodStartDate: Payment.mockJanuary.periodStartDate,
        periodEndDate: Payment.mockJanuary.periodEndDate
    )
}

#Preview("Cargado") {
    NavigationStack {
        ReceiptView(paymentID: Payment.mockJanuary.id)
    }
}
