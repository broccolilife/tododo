import SwiftUI
import SwiftData

@main
struct HealingTodoAppApp: App {
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([Task.self, Category.self, UserSettings.self, DailyStreak.self, ReminderConfig.self])
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView()
            } else {
                InboxView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
