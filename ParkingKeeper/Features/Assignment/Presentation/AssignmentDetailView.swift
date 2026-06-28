import SwiftUI

struct AssignmentDetailView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss
    @State private var viewState: ViewState
    @State private var showingBajaAlert = false

    private let assignmentID: UUID

    init(assignmentID: UUID) {
        self.assignmentID = assignmentID
        _viewState = State(initialValue: .loaded(AssignmentDetailView.effectiveModel(for: assignmentID)))
    }

    var body: some View {
        content
            .toolbar { toolbar }
            .alert("Dar de baja", isPresented: $showingBajaAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Dar de baja", role: .destructive) { confirmBaja() }
            } message: {
                Text("¿Confirmas que quieres dar de baja esta asignación? La plaza quedará libre.")
            }
    }
}

// MARK: - Subviews
private extension AssignmentDetailView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if case .loaded(let model) = viewState, model.isActive {
                Button("Dar de baja", role: .destructive) {
                    showingBajaAlert = true
                }
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
        List {
            Section("Cliente") {
                LabeledContent("Nombre", value: model.clientName)
            }
            Section("Vehículo") {
                LabeledContent("Matrícula", value: model.licensePlate)
            }
            Section("Plaza") {
                LabeledContent("Número", value: "\(model.spotNumber)")
            }
            Section("Fechas") {
                LabeledContent("Inicio", value: model.startDate.formatted(date: .abbreviated, time: .omitted))
                if let endDate = model.endDate {
                    LabeledContent("Fin", value: endDate.formatted(date: .abbreviated, time: .omitted))
                } else {
                    LabeledContent("Estado", value: "Activa")
                }
            }
            Section("Tarifa") {
                LabeledContent("Cuota mensual", value: "\(model.monthlyRate.formatted(.currency(code: "EUR")))")
            }
        }
        .navigationTitle("Asignación")
    }
}

// MARK: - Methods
private extension AssignmentDetailView {
    func confirmBaja() {
        dismiss()
    }
}

// MARK: - Subtypes
extension AssignmentDetailView {
    struct Model {
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
        let isActive: Bool
    }

    enum ViewState {
        case loading
        case loaded(Model)
        case error(String)
    }

    static let mockModel = Model(
        id: Assignment.mockActive.id,
        clientID: Client.mockMaria.id,
        clientName: Client.mockMaria.name,
        vehicleID: Vehicle.mockSeatLeon.id,
        licensePlate: Vehicle.mockSeatLeon.licensePlate,
        spotID: Spot.mockSpot2.id,
        spotNumber: Spot.mockSpot2.number,
        startDate: Assignment.mockActive.startDate,
        endDate: nil,
        monthlyRate: Assignment.mockActive.monthlyRate,
        isActive: true
    )

    static func effectiveModel(for assignmentID: UUID) -> Model {
        if DemoData.isEnabled, let a = DemoData.assignments.first(where: { $0.id == assignmentID }) {
            let client = DemoData.clients.first { $0.id == a.clientID }
            let vehicle = DemoData.vehicles.first { $0.id == a.vehicleID }
            let spot = DemoData.spots.first { $0.id == a.spotID }
            return Model(
                id: a.id, clientID: a.clientID,
                clientName: client?.name ?? "—",
                vehicleID: a.vehicleID,
                licensePlate: vehicle?.licensePlate ?? "—",
                spotID: a.spotID,
                spotNumber: spot?.number ?? 0,
                startDate: a.startDate, endDate: a.endDate,
                monthlyRate: a.monthlyRate,
                isActive: a.endDate == nil
            )
        }
        return mockModel
    }
}

#Preview("Cargado") {
    NavigationStack {
        AssignmentDetailView(assignmentID: Assignment.mockActive.id)
    }
    .environment(NavigationCoordinator())
}
