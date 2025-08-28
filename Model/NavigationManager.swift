import SwiftUI

enum AppScreen: Hashable {
    case home
    case levelSelect
    case level(Levelq)
    case about
}

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to screen: AppScreen) {
        path.append(screen)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
