import SwiftUI

struct DashboardView: View {
    @State private var viewState: ViewState = .loaded(DashboardView.effectiveMockModel)

    var body: some View {
        content
    }
}

// MARK: - Subviews
private extension DashboardView {
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
                statGrid(model)
                revenueCard(model)
            }
            .padding()
        }
    }

    func statGrid(_ model: Model) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCard(title: "Plazas totales", value: "\(model.totalSpots)", systemImage: "parkingsign", color: .blue)
            statCard(title: "Ocupadas", value: "\(model.occupiedSpots)", systemImage: "car.fill", color: .red)
            statCard(title: "Libres", value: "\(model.freeSpots)", systemImage: "car", color: .green)
            statCard(title: "Clientes", value: "\(model.totalClients)", systemImage: "person.2", color: .indigo)
            statCard(title: "Asignaciones", value: "\(model.totalAssignments)", systemImage: "arrow.triangle.swap", color: .purple)
            statCard(title: "Pendientes", value: "\(model.pendingPayments)", systemImage: "creditcard", color: .orange)
        }
    }

    func revenueCard(_ model: Model) -> some View {
        VStack(spacing: 8) {
            Text("Facturación mensual estimada")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(model.monthlyRevenue.formatted(.currency(code: "EUR")))")
                .font(.title)
                .bold()
                .foregroundStyle(.green)
            Text("\(model.totalAssignments) plazas activas")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }

    func statCard(title: String, value: String, systemImage: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title2)
                .bold()
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Subtypes
extension DashboardView {
    struct Model {
        let totalSpots: Int
        let occupiedSpots: Int
        let freeSpots: Int
        let totalClients: Int
        let totalAssignments: Int
        let pendingPayments: Int
        let monthlyRevenue: Double
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)
    }

    static let mockModel = Model(
        totalSpots: 6, occupiedSpots: 2, freeSpots: 4,
        totalClients: 3, totalAssignments: 2,
        pendingPayments: 1, monthlyRevenue: 155
    )

    static var effectiveMockModel: Model {
        if DemoData.isEnabled {
            let occupied = DemoData.spots.filter { $0.status == .occupied }.count
            let total = DemoData.spots.count
            let currentMonth = Calendar.current.component(.month, from: Date())

            let activeAssignments = DemoData.assignments.filter { $0.endDate == nil }
            let revenue = activeAssignments.reduce(0) { $0 + $1.monthlyRate }

            var pending = 0
            for assignment in activeAssignments {
                let startMonth = Calendar.current.component(.month, from: assignment.startDate)
                let expected = max(0, currentMonth - startMonth + 1)
                let actual = DemoData.payments.filter { $0.assignmentID == assignment.id }.count
                pending += max(0, expected - actual)
            }

            return Model(
                totalSpots: total,
                occupiedSpots: occupied,
                freeSpots: total - occupied,
                totalClients: DemoData.clients.count,
                totalAssignments: activeAssignments.count,
                pendingPayments: pending,
                monthlyRevenue: revenue
            )
        }
        return mockModel
    }
}

#Preview("Cargado") {
    DashboardView()
}
