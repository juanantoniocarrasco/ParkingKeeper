import SwiftUI

struct AppRootView: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    var body: some View {
        TabView(selection: Binding(
            get: { coordinator.selectedTab },
            set: { coordinator.selectedTab = $0 }
        )) {
            dashboardTab
            clientsTab
            spotsTab
            paymentsTab
        }
    }
}

// MARK: - Subviews
private extension AppRootView {
    var dashboardTab: some View {
        NavigationStack(path: coordinator.currentPath) {
            DashboardView()
                .navigationTitle("Dashboard")
                .navigationDestination(for: PKScreen.self) { screen in
                    NavigationAssembler.buildView(for: screen)
                }
        }
        .tabItem {
            Label(AppTab.dashboard.title, systemImage: AppTab.dashboard.icon)
        }
        .tag(AppTab.dashboard)
    }

    var clientsTab: some View {
        NavigationStack(path: coordinator.currentPath) {
            ClientListView()
                .navigationTitle("Clientes")
                .navigationDestination(for: PKScreen.self) { screen in
                    NavigationAssembler.buildView(for: screen)
                }
        }
        .tabItem {
            Label(AppTab.clients.title, systemImage: AppTab.clients.icon)
        }
        .tag(AppTab.clients)
    }

    var spotsTab: some View {
        NavigationStack(path: coordinator.currentPath) {
            SpotGridView()
                .navigationTitle("Plazas")
                .navigationDestination(for: PKScreen.self) { screen in
                    NavigationAssembler.buildView(for: screen)
                }
        }
        .tabItem {
            Label(AppTab.spots.title, systemImage: AppTab.spots.icon)
        }
        .tag(AppTab.spots)
    }

    var paymentsTab: some View {
        NavigationStack(path: coordinator.currentPath) {
            PaymentListView()
                .navigationTitle("Pagos")
                .navigationDestination(for: PKScreen.self) { screen in
                    NavigationAssembler.buildView(for: screen)
                }
        }
        .tabItem {
            Label(AppTab.payments.title, systemImage: AppTab.payments.icon)
        }
        .tag(AppTab.payments)
    }
}

#Preview {
    AppRootView()
        .environment(NavigationCoordinator())
}
