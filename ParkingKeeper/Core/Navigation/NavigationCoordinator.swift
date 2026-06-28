import SwiftUI

enum AppTab: CaseIterable {
    case dashboard
    case gestion

    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .gestion: return "Gestión"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "rectangle.grid.1x2"
        case .gestion: return "list.bullet"
        }
    }
}

@Observable
final class NavigationCoordinator {
    var selectedTab: AppTab = .dashboard

    var dashboardPath = NavigationPath()
    var gestionPath = NavigationPath()

    var presentedSheet: PKScreen?

    func navigate(to screen: PKScreen) {
        switch selectedTab {
        case .dashboard: dashboardPath.append(screen)
        case .gestion: gestionPath.append(screen)
        }
    }
}
