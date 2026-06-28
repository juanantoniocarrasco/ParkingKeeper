import SwiftUI

enum NavigationAssembler {
    @ViewBuilder
    static func buildView(for screen: PKScreen) -> some View {
        switch screen {
        case .dashboard:
            placeholder(title: "Dashboard")
                .navigationTitle(title(for: screen))
        case .clientList:
            ClientListView()
                .navigationTitle(title(for: screen))
        case .clientDetail(let client):
            ClientDetailView(clientID: client.id)
        case .clientForm(let client):
            ClientFormView(model: ClientViewMapper.toFormModel(client))
        case .vehicleList:
            placeholder(title: "Vehicles")
                .navigationTitle(title(for: screen))
        case .vehicleForm(let vehicle):
            placeholder(title: vehicle != nil ? "Edit Vehicle" : "New Vehicle")
                .navigationTitle(vehicle?.licensePlate ?? "New Vehicle")
        case .spotGrid:
            placeholder(title: "Spots")
                .navigationTitle(title(for: screen))
        case .assignmentList:
            placeholder(title: "Assignments")
                .navigationTitle(title(for: screen))
        case .assignmentDetail(let assignment):
            placeholder(title: "Assignment")
                .navigationTitle(assignment.startDate.formatted())
        case .paymentList:
            placeholder(title: "Payments")
                .navigationTitle(title(for: screen))
        case .paymentForm:
            placeholder(title: "Payment")
                .navigationTitle(title(for: screen))
        }
    }

    static func title(for screen: PKScreen) -> String {
        switch screen {
        case .dashboard: return "Dashboard"
        case .clientList: return "Clients"
        case .clientDetail: return "Client"
        case .clientForm: return "Client"
        case .vehicleList: return "Vehicles"
        case .vehicleForm: return "Vehicle"
        case .spotGrid: return "Spots"
        case .assignmentList: return "Assignments"
        case .assignmentDetail: return "Assignment"
        case .paymentList: return "Payments"
        case .paymentForm: return "Payment"
        }
    }

    @ViewBuilder
    private static func placeholder(title: String) -> some View {
        VStack {
            Text(title)
                .font(.largeTitle)
            Text("Coming soon")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
