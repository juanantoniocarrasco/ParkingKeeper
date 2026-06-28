import SwiftUI

struct AppRootView: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    var body: some View {
        TabView(selection: Binding(
            get: { coordinator.selectedTab },
            set: { coordinator.selectedTab = $0 }
        )) {
            dashboardTab
            gestionTab
        }
    }
}

// MARK: - Subviews
private extension AppRootView {
    var dashboardTab: some View {
        NavigationStack(path: Binding(
            get: { coordinator.dashboardPath },
            set: { coordinator.dashboardPath = $0 }
        )) {
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

    var gestionTab: some View {
        NavigationStack(path: Binding(
            get: { coordinator.gestionPath },
            set: { coordinator.gestionPath = $0 }
        )) {
            GestionView()
                .navigationDestination(for: PKScreen.self) { screen in
                    NavigationAssembler.buildView(for: screen)
                }
        }
        .tabItem {
            Label(AppTab.gestion.title, systemImage: AppTab.gestion.icon)
        }
        .tag(AppTab.gestion)
    }
}

#Preview {
    AppRootView()
        .environment(NavigationCoordinator())
}
