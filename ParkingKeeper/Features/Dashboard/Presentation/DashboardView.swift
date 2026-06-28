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
            VStack(spacing: 20) {
                header(model)
                occupancyCard(model)
                statsGrid(model)
                revenueBanner(model)
            }
            .padding()
        }
    }

    func header(_ model: Model) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Parking Keeper")
                    .font(.title2)
                    .bold()
                Text(Date().formatted(date: .long, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(model.totalAssignments)")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.blue)
            +
            Text(" activas")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    func occupancyCard(_ model: Model) -> some View {
        let ratio = Double(model.occupiedSpots) / Double(model.totalSpots)
        return HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(.quaternary, lineWidth: 8)
                Circle()
                    .trim(from: 0, to: ratio)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("\(model.occupiedSpots)/\(model.totalSpots)")
                        .font(.title3)
                        .bold()
                    Text("ocupadas")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 80, height: 80)

            VStack(alignment: .leading, spacing: 8) {
                Text("Ocupación")
                    .font(.headline)
                HStack(spacing: 16) {
                    occupancyStat(color: .blue, label: "Ocupadas", value: model.occupiedSpots)
                    occupancyStat(color: .green, label: "Libres", value: model.freeSpots)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    func occupancyStat(color: Color, label: String, value: Int) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text("\(value)")
                .font(.title3)
                .bold()
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    func statsGrid(_ model: Model) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            miniCard(
                icon: "person.2.fill",
                value: "\(model.totalClients)",
                label: "Clientes",
                color: .indigo
            )
            miniCard(
                icon: "creditcard.fill",
                value: "\(model.pendingPayments)",
                label: "Pendientes",
                color: .orange
            )
            miniCard(
                icon: "eurosign.circle.fill",
                value: "\(model.monthlyRevenue.formatted(.currency(code: "EUR")))",
                label: "al mes",
                color: .green
            )
            miniCard(
                icon: "arrow.triangle.swap",
                value: "\(model.totalAssignments)",
                label: "Asignaciones",
                color: .purple
            )
        }
    }

    func miniCard(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title2)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    func revenueBanner(_ model: Model) -> some View {
        HStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.title)
                .foregroundStyle(.green)
            VStack(alignment: .leading, spacing: 2) {
                Text("Facturación estimada")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(model.monthlyRevenue.formatted(.currency(code: "EUR")))/mes")
                    .font(.headline)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
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
            let activeClients = Set(activeAssignments.map(\.clientID)).count
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
                totalClients: activeClients,
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
