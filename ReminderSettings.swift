import SwiftUI
import SwiftData

// MARK: - Reminder Configuration Model

@Model
final class ReminderConfig: Identifiable {
    @Attribute(.unique) var id: UUID
    var isEnabled: Bool
    var hour: Int
    var minute: Int
    var daysOfWeek: [Int] // 1=Sun, 2=Mon, ..., 7=Sat
    var message: String
    var soundEnabled: Bool

    init(
        id: UUID = UUID(),
        isEnabled: Bool = true,
        hour: Int = 9,
        minute: Int = 0,
        daysOfWeek: [Int] = [2, 3, 4, 5, 6], // Mon-Fri
        message: String = "Take a gentle moment to review your tasks 🌿",
        soundEnabled: Bool = true
    ) {
        self.id = id
        self.isEnabled = isEnabled
        self.hour = hour
        self.minute = minute
        self.daysOfWeek = daysOfWeek
        self.message = message
        self.soundEnabled = soundEnabled
    }
}

// MARK: - Reminder Settings View

struct ReminderSettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var configs: [ReminderConfig]

    @State private var isEnabled = true
    @State private var selectedTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? .now
    @State private var selectedDays: Set<Int> = [2, 3, 4, 5, 6]
    @State private var message = "Take a gentle moment to review your tasks 🌿"
    @State private var soundEnabled = true

    private let dayNames = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        NavigationStack {
            ZStack {
                AuroraBackground()
                    .blur(radius: 12)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Enable toggle
                        GlassCard(tint: Palette.color(for: "Calm")) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Gentle Reminders")
                                        .font(.headline)
                                    Text("A soft nudge to check in with your tasks")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Toggle("", isOn: $isEnabled)
                                    .labelsHidden()
                                    .tint(Palette.color(for: "Health"))
                            }
                        }

                        if isEnabled {
                            // Time picker
                            GlassCard(tint: Palette.color(for: "Calm")) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Reminder Time")
                                        .font(.headline)
                                    DatePicker(
                                        "Time",
                                        selection: $selectedTime,
                                        displayedComponents: .hourAndMinute
                                    )
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                    .frame(maxHeight: 120)
                                }
                            }

                            // Days of week
                            GlassCard(tint: Palette.color(for: "Calm")) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Active Days")
                                        .font(.headline)
                                    HStack(spacing: 8) {
                                        ForEach(1...7, id: \.self) { day in
                                            let isSelected = selectedDays.contains(day)
                                            Button {
                                                Haptic.play(.tapLight)
                                                if isSelected {
                                                    selectedDays.remove(day)
                                                } else {
                                                    selectedDays.insert(day)
                                                }
                                            } label: {
                                                Text(dayNames[day - 1])
                                                    .font(.footnote.weight(.semibold))
                                                    .frame(width: 36, height: 36)
                                                    .background(
                                                        Circle()
                                                            .fill(isSelected
                                                                  ? Palette.color(for: "Health").opacity(0.5)
                                                                  : Color.white.opacity(0.1))
                                                    )
                                                    .foregroundStyle(isSelected ? .primary : .secondary)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }

                            // Custom message
                            GlassCard(tint: Palette.color(for: "Calm")) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Notification Message")
                                        .font(.headline)
                                    TextField("Your gentle reminder...", text: $message)
                                        .textFieldStyle(.roundedBorder)
                                        .font(.body)
                                }
                            }

                            // Sound toggle
                            GlassCard(tint: Palette.color(for: "Calm")) {
                                HStack {
                                    Label("Notification Sound", systemImage: "speaker.wave.2.fill")
                                        .font(.subheadline)
                                    Spacer()
                                    Toggle("", isOn: $soundEnabled)
                                        .labelsHidden()
                                        .tint(Palette.color(for: "Health"))
                                }
                            }

                            // Preset messages
                            GlassCard(tint: Palette.color(for: "Calm")) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Quick Presets")
                                        .font(.headline)
                                    ForEach(presetMessages, id: \.self) { preset in
                                        Button {
                                            message = preset
                                            Haptic.play(.tapLight)
                                        } label: {
                                            Text(preset)
                                                .font(.footnote)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 10)
                                                .background(
                                                    Capsule()
                                                        .fill(message == preset
                                                              ? Palette.color(for: "Health").opacity(0.3)
                                                              : Color.white.opacity(0.08))
                                                )
                                                .foregroundStyle(message == preset ? .primary : .secondary)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveConfig()
                        Haptic.play(.completeSuccess)
                        dismiss()
                    }
                    .font(.headline)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear(perform: loadExisting)
        }
    }

    private var presetMessages: [String] {
        [
            "Take a gentle moment to review your tasks 🌿",
            "Your garden is waiting — check in with your todos 🌱",
            "A few minutes of focus can grow into something beautiful 🌸",
            "Breathe, then tackle one small thing today 🍃",
            "Time to tend your garden of intentions 🌻",
        ]
    }

    private func loadExisting() {
        guard let config = configs.first else { return }
        isEnabled = config.isEnabled
        selectedTime = Calendar.current.date(from: DateComponents(hour: config.hour, minute: config.minute)) ?? selectedTime
        selectedDays = Set(config.daysOfWeek)
        message = config.message
        soundEnabled = config.soundEnabled
    }

    private func saveConfig() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)

        if let existing = configs.first {
            existing.isEnabled = isEnabled
            existing.hour = components.hour ?? 9
            existing.minute = components.minute ?? 0
            existing.daysOfWeek = Array(selectedDays).sorted()
            existing.message = message
            existing.soundEnabled = soundEnabled
        } else {
            let config = ReminderConfig(
                isEnabled: isEnabled,
                hour: components.hour ?? 9,
                minute: components.minute ?? 0,
                daysOfWeek: Array(selectedDays).sorted(),
                message: message,
                soundEnabled: soundEnabled
            )
            context.insert(config)
        }

        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save reminder config: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ReminderSettingsView()
        .modelContainer(PreviewSampleData.container)
}
