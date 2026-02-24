import SwiftUI
import SwiftData
import TipKit

/// App entry point. Configures a shared SwiftData ModelContainer with the full schema
/// (Task, Category, UserSettings) and injects it into the view hierarchy.
@main
struct HealingTodoAppApp: App {
    init() {
        OnboardingConfig.setup()
    }

    /// Shared model container — created once at launch. Crash on schema failure
    /// since the app cannot function without persistence.
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([Task.self, Category.self, UserSettings.self])
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            InboxView()
        }
        .modelContainer(sharedModelContainer)
    }
}
