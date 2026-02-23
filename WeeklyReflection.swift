import SwiftUI
import SwiftData

// MARK: - Weekly Reflection Data

struct WeekSummary {
    let weekStart: Date
    let weekEnd: Date
    let totalCompleted: Int
    let totalCreated: Int
    let completionRate: Double
    let busiestDay: String?
    let topCategory: String?
    let streakDays: Int
}

func computeWeekSummary(tasks: [Task], streakEntries: [DailyStreak]) -> WeekSummary {
    let cal = Calendar.current
    let today = cal.startOfDay(for: .now)
    let weekStart = cal.date(byAdding: .day, value: -6, to: today)!

    let weekTasks = tasks.filter { task in
        let created = cal.startOfDay(for: task.createdAt)
        return created >= weekStart && created <= today
    }

    let completed = weekTasks.filter { $0.isDone }

    // Busiest day
    var dayCount: [String: Int] = [:]
    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "EEEE"
    for task in completed {
        if let completedAt = task.completedAt {
            let dayName = dayFormatter.string(from: completedAt)
            dayCount[dayName, default: 0] += 1
        }
    }
    let busiestDay = dayCount.max(by: { $0.value < $1.value })?.key

    // Top category
    var catCount: [String: Int] = [:]
    for task in completed {
        let catName = task.category?.name ?? "Inbox"
        catCount[catName, default: 0] += 1
    }
    let topCategory = catCount.max(by: { $0.value < $1.value })?.key

    // Streak days this week
    let weekEntries = streakEntries.filter { entry in
        let day = cal.startOfDay(for: entry.date)
        return day >= weekStart && day <= today && entry.tasksCompleted > 0
    }

    let rate = weekTasks.isEmpty ? 0.0 : Double(completed.count) / Double(weekTasks.count)

    return WeekSummary(
        weekStart: weekStart,
        weekEnd: today,
        totalCompleted: completed.count,
        totalCreated: weekTasks.count,
        completionRate: rate,
        busiestDay: busiestDay,
        topCategory: topCategory,
        streakDays: weekEntries.count
    )
}

// MARK: - Weekly Reflection View

struct WeeklyReflectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var allTasks: [Task]
    @Query private var streakEntries: [DailyStreak]

    private var summary: WeekSummary {
        computeWeekSummary(tasks: allTasks, streakEntries: streakEntries)
    }

    private var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: summary.weekStart)) – \(formatter.string(from: summary.weekEnd))"
    }

    private var encouragement: String {
        switch summary.completionRate {
        case 0.8...:
            return "Amazing week! Your garden is thriving 🌸"
        case 0.5..<0.8:
            return "Good progress — keep nurturing your goals 🌿"
        case 0.1..<0.5:
            return "Every small step counts. Be gentle with yourself 🌱"
        default:
            return "A new week, a fresh start. You've got this 💚"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AuroraBackground()
                    .blur(radius: 12)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 6) {
                            Text("Weekly Reflection")
                                .font(.title2.weight(.bold))
                            Text(dateRange)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 8)

                        // Encouragement
                        GlassCard(tint: Palette.color(for: "Health")) {
                            Text(encouragement)
                                .font(.body.weight(.medium))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }

                        // Stats grid
                        HStack(spacing: 12) {
                            statCard(
                                value: "\(summary.totalCompleted)",
                                label: "Completed",
                                icon: "checkmark.circle.fill",
                                color: "Health"
                            )
                            statCard(
                                value: "\(summary.totalCreated)",
                                label: "Created",
                                icon: "plus.circle.fill",
                                color: "Work"
                            )
                        }

                        HStack(spacing: 12) {
                            statCard(
                                value: "\(Int(summary.completionRate * 100))%",
                                label: "Completion",
                                icon: "chart.bar.fill",
                                color: "Learning"
                            )
                            statCard(
                                value: "\(summary.streakDays)/7",
                                label: "Active Days",
                                icon: "flame.fill",
                                color: "Errands"
                            )
                        }

                        // Insights
                        GlassCard(tint: Palette.color(for: "Calm")) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Insights")
                                    .font(.headline)

                                if let busiest = summary.busiestDay {
                                    Label {
                                        Text("Most productive on **\(busiest)**")
                                    } icon: {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(Palette.color(for: "Errands"))
                                    }
                                    .font(.subheadline)
                                }

                                if let top = summary.topCategory {
                                    Label {
                                        Text("Top category: **\(top)**")
                                    } icon: {
                                        Image(systemName: "folder.fill")
                                            .foregroundStyle(Palette.color(for: "Work"))
                                    }
                                    .font(.subheadline)
                                }

                                if summary.totalCompleted == 0 {
                                    Text("No tasks completed this week — that's okay. Rest is productive too. 🍃")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        // Completion ring
                        GlassCard(tint: Palette.color(for: "Health")) {
                            VStack(spacing: 12) {
                                Text("Weekly Progress")
                                    .font(.headline)

                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 10)
                                        .frame(width: 120, height: 120)
                                    Circle()
                                        .trim(from: 0, to: summary.completionRate)
                                        .stroke(
                                            Palette.color(for: "Health"),
                                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                        )
                                        .frame(width: 120, height: 120)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.spring(response: 0.8), value: summary.completionRate)
                                    Text("\(Int(summary.completionRate * 100))%")
                                        .font(.title2.weight(.bold))
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func statCard(value: String, label: String, icon: String, color: String) -> some View {
        GlassCard(tint: Palette.color(for: color)) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Palette.color(for: color))
                Text(value)
                    .font(.title.weight(.bold))
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    WeeklyReflectionView()
        .modelContainer(PreviewSampleData.container)
}
