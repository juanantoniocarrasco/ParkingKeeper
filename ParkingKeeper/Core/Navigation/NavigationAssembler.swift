import SwiftUI

enum NavigationAssembler {
    @ViewBuilder
    static func buildView(for screen: PKScreen) -> some View {
        switch screen {
        case .dashboard:
            DashboardView()
                .navigationTitle(title(for: screen))
        case .clientList:
            ClientListView()
                .navigationTitle(title(for: screen))
        case .clientDetail(let client):
            ClientDetailView(clientID: client.id)
        case .clientForm(let client):
            ClientFormView(model: ClientViewMapper.toFormModel(client))
        case .vehicleList:
            VehicleListView()
                .navigationTitle(title(for: screen))
        case .vehicleForm(let vehicle):
            VehicleFormView(model: VehicleViewMapper.toFormModel(vehicle))
        case .spotGrid:
            SpotGridView()
                .navigationTitle(title(for: screen))
        case .assignmentList:
            AssignmentListView()
                .navigationTitle(title(for: screen))
        case .assignmentDetail(let assignment):
            AssignmentDetailView(assignmentID: assignment.id)
        case .assignmentForm(let assignment):
            AssignmentFormView(model: AssignmentViewMapper.toFormModel(assignment))
        case .paymentList:
            PaymentListView()
                .navigationTitle(title(for: screen))
        case .paymentForm(let payment):
            PaymentFormView(model: PaymentViewMapper.toFormModel(payment))
        case .annualGrid:
            AnnualGridView()
                .navigationTitle(title(for: screen))
        }
    }

    static func title(for screen: PKScreen) -> String {
        switch screen {
        case .dashboard: return "Dashboard"
        case .clientList: return "Clientes"
        case .clientDetail: return "Cliente"
        case .clientForm: return "Cliente"
        case .vehicleList: return "Vehículos"
        case .vehicleForm: return "Vehículo"
        case .spotGrid: return "Plazas"
        case .assignmentList: return "Asignaciones"
        case .assignmentDetail: return "Asignación"
        case .assignmentForm: return "Asignación"
        case .paymentList: return "Pagos"
        case .paymentForm: return "Pago"
        case .annualGrid: return "Cuadrante anual"
        }
    }

    @ViewBuilder
    private static func placeholder(title: String) -> some View {
        VStack {
            Text(title)
                .font(.largeTitle)
            Text("Próximamente")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
