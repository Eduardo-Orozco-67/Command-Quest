import SwiftUI

@main
struct MyApp: App {
    @StateObject private var navigation = NavigationManager()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(navigation) // Inyectamos NavigationManager
        }
    }
}
