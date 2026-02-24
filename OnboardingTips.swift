import SwiftUI
import TipKit

// MARK: - TipKit Onboarding
// Progressive disclosure: tips appear contextually as users explore.
// Rule: Show core value in < 3 taps. No signup walls.

/// First-time: explain the inbox concept
struct InboxWelcomeTip: Tip {
    var title: Text {
        Text("Your Healing Inbox")
    }

    var message: Text? {
        Text("Add tasks gently. Tap a task to mark it done — it'll float away peacefully.")
    }

    var image: Image? {
        Image(systemName: "sparkles")
    }
}

/// Explain category orbs
struct CategoryOrbTip: Tip {
    @Parameter
    static var tasksCreated: Int = 0

    var title: Text {
        Text("Organize with Orbs")
    }

    var message: Text? {
        Text("Drag tasks onto category orbs to organize, or tap the icon on any task to pick a category.")
    }

    var image: Image? {
        Image(systemName: "circle.grid.cross.fill")
    }

    var rules: [Rule] {
        [
            #Rule(Self.$tasksCreated) { $0 >= 2 }
        ]
    }
}

/// Explain drag-to-categorize
struct DragToCategorize: Tip {
    @Parameter
    static var hasTappedCategory: Bool = false

    var title: Text {
        Text("Press & Drag")
    }

    var message: Text? {
        Text("Long-press the category icon and drag to quickly pick a new home for your task.")
    }

    var image: Image? {
        Image(systemName: "hand.draw")
    }

    var rules: [Rule] {
        [
            #Rule(Self.$hasTappedCategory) { $0 == true }
        ]
    }
}

/// Celebrate first completion
struct FirstCompletionTip: Tip {
    @Parameter
    static var hasCompletedTask: Bool = false

    var title: Text {
        Text("✨ Beautiful!")
    }

    var message: Text? {
        Text("One gentle step forward. You're doing great.")
    }

    var rules: [Rule] {
        [
            #Rule(Self.$hasCompletedTask) { $0 == true }
        ]
    }
}

// MARK: - Configuration

enum OnboardingConfig {
    static func setup() {
        try? Tips.configure([
            .displayFrequency(.daily),
            .datastoreLocation(.applicationDefault)
        ])
    }
}
