import SwiftUI
import SwiftData

@main
struct BrewWaterChemistApp: App {
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .onOpenURL { url in
                    router.handleURL(url)
                }
        }
        .modelContainer(for: [Recipe.self, AppSettings.self])
    }
}
