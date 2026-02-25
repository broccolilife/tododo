import SwiftUI

// MARK: - App Typography

/// Semantic typography scale with consistent weights and optical sizing.
/// Use these instead of raw `.font()` calls for design consistency.
enum AppTypography {

    // MARK: - Display

    /// Large display text — splash screens, win overlays
    static let displayLarge: Font = .system(size: 34, weight: .bold, design: .rounded)

    /// Medium display — section heroes, empty states
    static let displayMedium: Font = .system(size: 28, weight: .bold, design: .rounded)

    // MARK: - Headings

    /// Primary heading — card titles, navigation
    static let heading: Font = .system(.headline, design: .rounded).weight(.semibold)

    /// Secondary heading — section labels
    static let subheading: Font = .system(.subheadline, design: .rounded).weight(.medium)

    // MARK: - Body

    /// Primary body text
    static let body: Font = .system(.body, design: .rounded)

    /// Secondary body — notes, descriptions
    static let bodySecondary: Font = .system(.subheadline, design: .rounded)

    // MARK: - Caption & Meta

    /// Small metadata — dates, timestamps
    static let caption: Font = .system(.footnote, design: .rounded)

    /// Tiny label — badge counts, annotations
    static let micro: Font = .system(.caption2, design: .rounded).weight(.medium)

    // MARK: - Monospaced

    /// Monospaced digits — timers, counters
    static let mono: Font = .system(.subheadline, design: .monospaced).weight(.medium)

    /// Large monospaced — prominent counters
    static let monoLarge: Font = .system(.title2, design: .monospaced).weight(.semibold)

    // MARK: - Special

    /// All-caps label with tracking
    static let uppercaseLabel: Font = .system(.caption, design: .rounded).weight(.semibold)
}

// MARK: - View Modifiers

extension View {
    /// Apply uppercase label style with letter spacing
    func uppercaseLabelStyle() -> some View {
        self
            .font(AppTypography.uppercaseLabel)
            .textCase(.uppercase)
            .kerning(1.5)
    }
}
