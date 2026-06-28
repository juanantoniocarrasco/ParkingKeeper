import SwiftUI

struct AssignmentListView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState = .loaded(AssignmentListView.effectiveMocks)
    @State private var showingActive = true

    var body: some View {
        content
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension AssignmentListView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                coordinator.navigationPath.append(PKScreen.assignmentForm(nil))
            } label: {
                Label("Nueva asignación", systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    var content: some View {
        switch viewState {
        case .loading:
            loadingView
        case .loaded(let assignments):
            loadedList(assignments)
        case .empty:
            emptyView
        case .error(let message):
            errorView(message)
        }
    }

    var loadingView: some View {
        ProgressView("Cargando asignaciones...")
    }

    var emptyView: some View {
        ContentUnavailableView(
            "Sin asignaciones",
            systemImage: "arrow.triangle.swap.slash",
            description: Text("Crea una asignación para empezar.")
        )
    }

    func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    func loadedList(_ assignments: [AssignmentRow]) -> some View {
        let active = assignments.filter { $0.endDate == nil }
        let historic = assignments.filter { $0.endDate != nil }
        let displayed = showingActive ? active : historic

        return List {
            Picker("Filtro", selection: $showingActive) {
                Text("Activas").tag(true)
                Text("Históricas").tag(false)
            }
            .pickerStyle(.segmented)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)

            if displayed.isEmpty {
                emptyFilterView
            } else {
                ForEach(displayed) { row in
                    NavigationLink(value: PKScreen.assignmentDetail(
                        Assignment(
                            id: row.id,
                            clientID: row.clientID,
                            vehicleID: row.vehicleID,
                            spotID: row.spotID,
                            startDate: row.startDate,
                            endDate: row.endDate,
                            monthlyRate: row.monthlyRate
                        )
                    )) {
                        assignmentRow(row)
                    }
                }
            }
        }
    }

    var emptyFilterView: some View {
        ContentUnavailableView(
            showingActive ? "Sin asignaciones activas" : "Sin asignaciones históricas",
            systemImage: "arrow.triangle.swap",
            description: Text("No hay datos para este filtro.")
        )
    }

    func assignmentRow(_ row: AssignmentRow) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Cliente: \(row.clientName)")
                    .font(.headline)
                Spacer()
                Text("Plaza \(row.spotNumber)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text(row.licensePlate)
                    .font(.caption)
                Spacer()
                if let endDate = row.endDate {
                    Text("Hasta \(endDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption2)
                        .foregroundStyle(.red)
                } else {
                    Text("Activa")
                        .font(.caption2)
                        .foregroundStyle(.green)
                }
            }
        }
    }
}

// MARK: - Subtypes
extension AssignmentListView {
    struct AssignmentRow: Identifiable {
        let id: UUID
        let clientID: UUID
        let clientName: String
        let vehicleID: UUID
        let licensePlate: String
        let spotID: UUID
        let spotNumber: Int
        let startDate: Date
        let endDate: Date?
        let monthlyRate: Double
    }

    enum ViewState {
        case loading
        case loaded([AssignmentRow])
        case empty
        case error(String)
    }

    static let mocks: [AssignmentRow] = [
        .init(
            id: Assignment.mockActive.id,
            clientID: Client.mockMaria.id,
            clientName: Client.mockMaria.name,
            vehicleID: Vehicle.mockSeatLeon.id,
            licensePlate: Vehicle.mockSeatLeon.licensePlate,
            spotID: Spot.mockSpot2.id,
            spotNumber: Spot.mockSpot2.number,
            startDate: Assignment.mockActive.startDate,
            endDate: nil,
            monthlyRate: Assignment.mockActive.monthlyRate
        ),
        .init(
            id: Assignment.mockHistoric.id,
            clientID: Client.mockCarlos.id,
            clientName: Client.mockCarlos.name,
            vehicleID: Vehicle.mockToyota.id,
            licensePlate: Vehicle.mockToyota.licensePlate,
            spotID: Spot.mockSpot4.id,
            spotNumber: Spot.mockSpot4.number,
            startDate: Assignment.mockHistoric.startDate,
            endDate: Assignment.mockHistoric.endDate,
            monthlyRate: Assignment.mockHistoric.monthlyRate
        ),
    ]

    static var effectiveMocks: [AssignmentRow] {
        if DemoData.isEnabled {
            return DemoData.assignments.map { a in
                let client = DemoData.clients.first { $0.id == a.clientID }
                let vehicle = DemoData.vehicles.first { $0.id == a.vehicleID }
                let spot = DemoData.spots.first { $0.id == a.spotID }
                return AssignmentRow(
                    id: a.id,
                    clientID: a.clientID,
                    clientName: client?.name ?? "—",
                    vehicleID: a.vehicleID,
                    licensePlate: vehicle?.licensePlate ?? "—",
                    spotID: a.spotID,
                    spotNumber: spot?.number ?? 0,
                    startDate: a.startDate,
                    endDate: a.endDate,
                    monthlyRate: a.monthlyRate
                )
            }
        }
        return mocks
    }
}

#Preview("Cargado") {
    NavigationStack {
        AssignmentListView()
    }
    .environment(NavigationCoordinator())
}
