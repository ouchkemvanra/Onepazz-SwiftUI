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
            .environmentObject(env.theme)
            .tint(env.theme.palette.accent)
        }
    }
}
