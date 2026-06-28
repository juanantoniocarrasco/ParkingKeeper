import SwiftUI

enum AppTab: CaseIterable {
    case dashboard
    case clients
    case spots
    case payments

    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .clients: return "Clientes"
        case .spots: return "Plazas"
        case .payments: return "Pagos"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "rectangle.grid.1x2"
        case .clients: return "person.2"
        case .spots: return "parkingsign"
        case .payments: return "creditcard"
        }
    }
}

@Observable
final class NavigationCoordinator {
    var selectedTab: AppTab = .dashboard

    var dashboardPath = NavigationPath()
    var clientsPath = NavigationPath()
    var spotsPath = NavigationPath()
    var paymentsPath = NavigationPath()

    var presentedSheet: PKScreen?

    var currentPath: Binding<NavigationPath> {
        switch selectedTab {
        case .dashboard: return Binding(get: { self.dashboardPath }, set: { self.dashboardPath = $0 })
        case .clients: return Binding(get: { self.clientsPath }, set: { self.clientsPath = $0 })
        case .spots: return Binding(get: { self.spotsPath }, set: { self.spotsPath = $0 })
        case .payments: return Binding(get: { self.paymentsPath }, set: { self.paymentsPath = $0 })
        }
    }

    func navigate(to screen: PKScreen) {
        switch selectedTab {
        case .dashboard: dashboardPath.append(screen)
        case .clients: clientsPath.append(screen)
        case .spots: spotsPath.append(screen)
        case .payments: paymentsPath.append(screen)
        }
    }
}
