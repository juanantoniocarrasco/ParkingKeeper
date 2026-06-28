import SwiftUI

struct ReceiptContent: View {
    let model: ReceiptView.Model

    var body: some View {
        VStack(spacing: 16) {
            header
            Divider()
            bodyContent
            Divider()
            footer
        }
        .padding(24)
    }
}

// MARK: - Subviews
private extension ReceiptContent {
    var header: some View {
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

    var bodyContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            row(label: "Cliente", value: model.clientName)
            row(label: "Vehículo", value: model.licensePlate)
            row(label: "Plaza", value: "\(model.spotNumber)")
            Divider()
            row(label: "Importe", value: "\(model.amount.formatted(.currency(code: "EUR")))")
            row(label: "Método", value: model.method == .cash ? "Efectivo" : "Bizum")
            row(label: "Período", value: periodLabel)
            row(label: "Fecha de pago", value: model.date.formatted(date: .long, time: .omitted))
        }
    }

    var footer: some View {
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

    var periodLabel: String {
        let start = model.periodStartDate.formatted(date: .abbreviated, time: .omitted)
        let end = model.periodEndDate.formatted(date: .abbreviated, time: .omitted)
        return "\(start) – \(end) (\(model.periodMonths) mes\(model.periodMonths > 1 ? "es" : ""))"
    }
}
