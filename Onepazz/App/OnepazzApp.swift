import SwiftUI

@main
struct OnepazzApp: App {
    @StateObject private var env = AppEnvironment()
    var body: some Scene {
        WindowGroup {
            Group {
                #if USE_COORDINATOR
                CoordinatorHost().ignoresSafeArea()
                #else
                AppRouter()
                #endif
            }
            .environmentObject(env)
            .themed(env.theme)
            .tint(Color(env.theme.colors.accent))
        }
    }
}
