import SwiftUI

struct AppRootView: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    var body: some View {
        NavigationSplitView {
            sidebar
#if os(macOS)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        } detail: {
            detail
        }
#if os(macOS)
        .navigationSplitViewStyle(.prominentDetail)
#endif
    }
}

// MARK: - Subviews
private extension AppRootView {
    var sidebar: some View {
        List(selection: Binding(
            get: { coordinator.selectedSidebarItem },
            set: { newItem in
                coordinator.selectedSidebarItem = newItem
                coordinator.navigationPath = NavigationPath()
            }
        )) {
            Section {
                sidebarRow(.dashboard)
                sidebarRow(.clientList)
                sidebarRow(.vehicleList)
                sidebarRow(.spotGrid)
                sidebarRow(.assignmentList)
                sidebarRow(.paymentList)
                sidebarRow(.annualGrid)
            }
        }
        .listStyle(.sidebar)
    }

    var detail: some View {
        NavigationStack(path: Binding(
            get: { coordinator.navigationPath },
            set: { coordinator.navigationPath = $0 }
        )) {
            NavigationAssembler.buildView(for: coordinator.selectedSidebarItem ?? .dashboard)
                .navigationDestination(for: PKScreen.self) { screen in
                    NavigationAssembler.buildView(for: screen)
                }
        }
        .id(coordinator.selectedSidebarItem)
    }

    func sidebarRow(_ screen: PKScreen) -> some View {
        Label(NavigationAssembler.title(for: screen), systemImage: screen.icon)
            .tag(screen)
    }
}

#Preview {
    AppRootView()
        .environment(NavigationCoordinator())
}
