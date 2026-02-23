import SwiftUI
import SwiftData

// MARK: - Streak Model

@Model
final class DailyStreak: Identifiable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var tasksCompleted: Int

    init(id: UUID = UUID(), date: Date = .now, tasksCompleted: Int = 0) {
        self.id = id
        self.date = date
        self.tasksCompleted = tasksCompleted
    }
}

// MARK: - Streak Computation

struct StreakInfo {
    let currentStreak: Int
    let longestStreak: Int
    let totalCompletedDays: Int
    let recentDays: [Date: Int] // last 28 days: date -> tasks completed
}

func computeStreak(entries: [DailyStreak]) -> StreakInfo {
    let cal = Calendar.current
    let today = cal.startOfDay(for: .now)

    let dayMap: [Date: Int] = entries.reduce(into: [:]) { result, entry in
        let day = cal.startOfDay(for: entry.date)
        result[day, default: 0] += entry.tasksCompleted
    }

    // Current streak (consecutive days ending today or yesterday)
    var current = 0
    var checkDate = today
    if dayMap[today] == nil {
        checkDate = cal.date(byAdding: .day, value: -1, to: today)!
    }
    while let count = dayMap[checkDate], count > 0 {
        current += 1
        checkDate = cal.date(byAdding: .day, value: -1, to: checkDate)!
    }

    // Longest streak
    let sortedDays = dayMap.keys.sorted()
    var longest = 0
    var run = 0
    var prevDay: Date?
    for day in sortedDays {
        guard (dayMap[day] ?? 0) > 0 else {
            run = 0
            prevDay = day
            continue
        }
        if let prev = prevDay, cal.dateComponents([.day], from: prev, to: day).day == 1 {
            run += 1
        } else {
            run = 1
        }
        longest = max(longest, run)
        prevDay = day
    }

    // Recent 28 days
    var recent: [Date: Int] = [:]
    for i in 0..<28 {
        let day = cal.date(byAdding: .day, value: -i, to: today)!
        recent[day] = dayMap[day] ?? 0
    }

    return StreakInfo(
        currentStreak: current,
        longestStreak: longest,
        totalCompletedDays: dayMap.values.filter { $0 > 0 }.count,
        recentDays: recent
    )
}

// MARK: - Garden Growth View

struct GardenGrowthView: View {
    let streakInfo: StreakInfo

    private let gardenStages: [(threshold: Int, emoji: String, label: String)] = [
        (0, "🌱", "Sprout"),
        (3, "🌿", "Seedling"),
        (7, "🪴", "Sapling"),
        (14, "🌳", "Young Tree"),
        (30, "🌲", "Mighty Tree"),
        (60, "🌸", "Blossoming"),
        (100, "🏡", "Full Garden"),
    ]

    private var currentStage: (emoji: String, label: String) {
        let stage = gardenStages.last { streakInfo.totalCompletedDays >= $0.threshold } ?? gardenStages[0]
        return (stage.emoji, stage.label)
    }

    private var nextStage: (emoji: String, label: String, daysNeeded: Int)? {
        guard let next = gardenStages.first(where: { streakInfo.totalCompletedDays < $0.threshold }) else {
            return nil
        }
        return (next.emoji, next.label, next.threshold - streakInfo.totalCompletedDays)
    }

    var body: some View {
        GlassCard(tint: Palette.color(for: "Health")) {
            VStack(spacing: 16) {
                Text("Your Garden")
                    .font(.headline)
                    .foregroundStyle(.primary)

                // Garden visual
                Text(currentStage.emoji)
                    .font(.system(size: 64))

                Text(currentStage.label)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                // Streak stats
                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("\(streakInfo.currentStreak)")
                            .font(.title.weight(.bold))
                            .foregroundStyle(Palette.color(for: "Health"))
                        Text("Current")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 4) {
                        Text("\(streakInfo.longestStreak)")
                            .font(.title.weight(.bold))
                            .foregroundStyle(Palette.color(for: "Play"))
                        Text("Longest")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 4) {
                        Text("\(streakInfo.totalCompletedDays)")
                            .font(.title.weight(.bold))
                            .foregroundStyle(Palette.color(for: "Learning"))
                        Text("Total Days")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // 28-day heatmap
                StreakHeatmap(recentDays: streakInfo.recentDays)

                // Progress to next stage
                if let next = nextStage {
                    HStack(spacing: 6) {
                        Text("Next: \(next.emoji) \(next.label)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("(\(next.daysNeeded) days)")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Palette.color(for: "Health"))
                    }
                } else {
                    Text("🎉 Garden fully grown!")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Palette.color(for: "Health"))
                }
            }
        }
    }
}

// MARK: - Streak Heatmap

struct StreakHeatmap: View {
    let recentDays: [Date: Int]

    private var sortedDays: [(date: Date, count: Int)] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: .now)
        return (0..<28).reversed().map { i in
            let day = cal.date(byAdding: .day, value: -i, to: today)!
            return (day, recentDays[day] ?? 0)
        }
    }

    private func intensity(for count: Int) -> Double {
        if count == 0 { return 0.08 }
        if count == 1 { return 0.3 }
        if count <= 3 { return 0.55 }
        return 0.85
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Last 28 Days")
                .font(.caption)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                ForEach(sortedDays, id: \.date) { day in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Palette.color(for: "Health").opacity(intensity(for: day.count)))
                        .frame(height: 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .strokeBorder(.white.opacity(0.1), lineWidth: 0.5)
                        )
                }
            }

            HStack {
                Text("Less")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                ForEach([0.08, 0.3, 0.55, 0.85], id: \.self) { opacity in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Palette.color(for: "Health").opacity(opacity))
                        .frame(width: 10, height: 10)
                }
                Text("More")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
