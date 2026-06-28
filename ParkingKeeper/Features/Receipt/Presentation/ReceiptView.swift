import SwiftUI

struct ReceiptView: View {
    @State private var viewState: ViewState
    @State private var pdfURL: URL?

    private let paymentID: UUID

    init(paymentID: UUID) {
        self.paymentID = paymentID
        _viewState = State(initialValue: .loaded(ReceiptView.mockModel))
    }

    var body: some View {
        content
            .toolbar { toolbar }
            .task(id: paymentID) {
                if case .loaded(let model) = viewState {
                    pdfURL = generatePDF(model: model)
                }
            }
    }
}

// MARK: - Subviews
private extension ReceiptView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if let pdfURL {
                ShareLink(item: pdfURL, preview: SharePreview("Recibo", image: Image(systemName: "doc.text")))
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
            ReceiptContent(model: model)
        }
    }
}

// MARK: - PDF generation
private extension ReceiptView {
    func generatePDF(model: Model) -> URL? {
        let renderer = ImageRenderer(content: ReceiptContent(model: model).frame(width: 540))
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("recibo-\(model.paymentID.uuidString.prefix(8)).pdf")

        try? FileManager.default.removeItem(at: url)

        renderer.render { size, render in
            var mediaBox = CGRect(origin: .zero, size: size)
            guard let consumer = CGDataConsumer(url: url as CFURL) else { return }
            guard let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else { return }
            ctx.beginPDFPage(nil)
            render(ctx)
            ctx.endPDFPage()
            ctx.closePDF()
        }

        return FileManager.default.fileExists(atPath: url.path) ? url : nil
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
