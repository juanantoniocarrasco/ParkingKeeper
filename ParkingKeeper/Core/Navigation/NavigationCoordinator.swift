import SwiftUI

@Observable
final class NavigationCoordinator {
    var navigationPath = NavigationPath()
    var presentedSheet: PKScreen?
    var presentedFullScreen: PKScreen?
    var selectedSidebarItem: PKScreen? = .dashboard
}
