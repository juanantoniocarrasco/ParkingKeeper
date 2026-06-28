import SwiftUI

struct GestionView: View {
    var body: some View {
        List {
            gestionRow(.clientList)
            gestionRow(.vehicleList)
            gestionRow(.spotGrid)
            gestionRow(.assignmentList)
            gestionRow(.paymentList)
            gestionRow(.annualGrid)
        }
        .navigationTitle("Gestión")
    }
}

// MARK: - Subviews
private extension GestionView {
    func gestionRow(_ screen: PKScreen) -> some View {
        NavigationLink(value: screen) {
            Label(NavigationAssembler.title(for: screen), systemImage: screen.icon)
        }
    }
}

#Preview {
    NavigationStack {
        GestionView()
    }
}
