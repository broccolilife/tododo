import SwiftUI

/// Reusable error state following Nielsen's Heuristic #9.
/// Pattern: Illustration → Clear message → What to do next → [Primary Action] → Secondary link
struct ErrorStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionLabel: String
    var secondaryLabel: String? = nil
    let action: () -> Void
    var secondaryAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: DS.Spacing.xxl) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            VStack(spacing: DS.Spacing.sm) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: DS.Spacing.md) {
                Button(action: action) {
                    Text(actionLabel)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.Spacing.md)
                        .background(Palette.color(for: "Calm"))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                if let secondaryLabel, let secondaryAction {
                    Button(action: secondaryAction) {
                        Text(secondaryLabel)
                            .font(.subheadline)
                            .foregroundStyle(Palette.color(for: "Calm"))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: 260)
        }
        .padding(DS.Spacing.xxxl)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Presets

extension ErrorStateView {
    /// Save failed — data persistence error
    static func saveFailed(retry: @escaping () -> Void) -> ErrorStateView {
        ErrorStateView(
            icon: "externaldrive.trianglebadge.exclamationmark",
            title: "Couldn't Save",
            message: "Your task wasn't saved. Check your storage and try again.",
            actionLabel: "Try Again",
            action: retry
        )
    }

    /// iCloud sync error
    static func syncFailed(retry: @escaping () -> Void) -> ErrorStateView {
        ErrorStateView(
            icon: "icloud.slash",
            title: "Sync Unavailable",
            message: "Couldn't connect to iCloud. Your tasks are safe locally — they'll sync when connection returns.",
            actionLabel: "Retry Sync",
            secondaryLabel: "Continue Offline",
            action: retry,
            secondaryAction: { }
        )
    }

    /// Empty search results
    static func noResults(query: String, clear: @escaping () -> Void) -> ErrorStateView {
        ErrorStateView(
            icon: "magnifyingglass",
            title: "No Results",
            message: "Nothing matches \"\(query)\". Try a different search term.",
            actionLabel: "Clear Search",
            action: clear
        )
    }
}

#Preview {
    ErrorStateView.saveFailed { }
        .background(Color.black)
}
