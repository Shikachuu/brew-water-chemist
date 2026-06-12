import SwiftUI
import SwiftData

@main
struct BrewWaterChemistApp: App {
    @State private var router = AppRouter()
    private let container: ModelContainer

    init() {
        // UI tests pass `-uitest-reset` to run against an isolated in-memory store, so every
        // test launches from an empty database that `RootView.seedIfNeeded()` then seeds with
        // the known defaults. Normal launches keep the persistent on-disk store.
        let inMemory = ProcessInfo.processInfo.arguments.contains("-uitest-reset")
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        do {
            container = try ModelContainer(
                for: Recipe.self, AppSettings.self,
                configurations: configuration
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .onOpenURL { url in
                    router.handleURL(url)
                }
                .onAppear {
                    // UI tests can't reliably fire a custom URL scheme at the app under test, so
                    // they pass the deep link via the environment; route it through the same
                    // handler `onOpenURL` uses.
                    if let urlString = ProcessInfo.processInfo.environment["UITEST_OPEN_URL"],
                       let url = URL(string: urlString) {
                        router.handleURL(url)
                    }
                }
        }
        .modelContainer(container)
    }
}
