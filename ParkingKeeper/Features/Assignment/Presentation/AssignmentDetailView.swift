import SwiftUI

struct AssignmentDetailView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var viewState: ViewState

    private let assignmentID: UUID

    init(assignmentID: UUID) {
        self.assignmentID = assignmentID
        _viewState = State(initialValue: .loaded(AssignmentDetailView.mockModel))
    }

    var body: some View {
        content
            .toolbar { toolbar }
    }
}

// MARK: - Subviews
private extension AssignmentDetailView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if case .loaded(let model) = viewState, model.isActive {
                Button("Dar de baja") {
                    coordinator.navigationPath.append(
                        PKScreen.assignmentForm(Assignment(
                            id: model.id,
                            clientID: model.clientID,
                            vehicleID: model.vehicleID,
                            spotID: model.spotID,
                            startDate: Date(),
                            endDate: Date(),
                            monthlyRate: model.monthlyRate
                        ))
                    )
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
}

#Preview("Cargado") {
    NavigationStack {
        AssignmentDetailView(assignmentID: Assignment.mockActive.id)
    }
    .environment(NavigationCoordinator())
}
