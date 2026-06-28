import SwiftUI

struct AppRootView: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            NavigationStack(path: Binding(
                get: { coordinator.navigationPath },
                set: { coordinator.navigationPath = $0 }
            )) {
                NavigationAssembler.buildView(for: .dashboard)
                    .navigationDestination(for: PKScreen.self) { screen in
                        NavigationAssembler.buildView(for: screen)
                    }
            }
        }
    }

    private var sidebar: some View {
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
            }
        }
    }

    private func sidebarRow(_ screen: PKScreen) -> some View {
        Label(NavigationAssembler.title(for: screen), systemImage: screen.icon)
            .tag(screen)
    }
}

#Preview {
    AppRootView()
        .environment(NavigationCoordinator())
}
