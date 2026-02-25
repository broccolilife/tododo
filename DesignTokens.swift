import SwiftUI

// MARK: - Design Tokens

/// Centralized design token system for consistent spacing, radii, shadows, and animations.
/// Inspired by Apple HIG and modern design systems. All magic numbers flow through here.
enum Tokens {

    // MARK: Spacing

    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }

    // MARK: Corner Radii

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 14
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let pill: CGFloat = 36
        static let orb: CGFloat = 24
    }

    // MARK: Shadows

    enum Shadow {
        static let cardRadius: CGFloat = 20
        static let cardY: CGFloat = 10
        static let cardOpacity: Double = 0.3

        static let floatingRadius: CGFloat = 16
        static let floatingY: CGFloat = 8
        static let floatingOpacity: Double = 0.28

        static let trayRadius: CGFloat = 28
        static let trayY: CGFloat = 14
        static let trayOpacity: Double = 0.3
    }

    // MARK: Spring Animations

    enum Spring {
        /// Snappy micro-interaction (button press, toggle)
        static let snappy = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)

        /// Standard interaction (picker open/close, card flip)
        static let standard = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8)

        /// Gentle, smooth motion (scroll-to, category assignment)
        static let gentle = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.82)

        /// Bouncy playful spring (completion celebration, orb bounce)
        static let bouncy = SwiftUI.Animation.spring(response: 0.45, dampingFraction: 0.6, blendDuration: 0.1)

        /// Quick dismiss (close sheet, dismiss picker)
        static let dismiss = SwiftUI.Animation.spring(response: 0.25, dampingFraction: 0.9)

        /// Liquid — organic, slightly underdamped for glass effects
        static let liquid = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.65)
    }

    // MARK: Border

    enum Border {
        static let glassWidth: CGFloat = 0.75
        static let subtleWidth: CGFloat = 0.5
        static let glassHighOpacity: Double = 0.55
        static let glassMidOpacity: Double = 0.15
        static let glassLowOpacity: Double = 0.05
    }

    // MARK: Duration

    enum Duration {
        static let instant: Double = 0.15
        static let fast: Double = 0.25
        static let normal: Double = 0.35
        static let slow: Double = 0.5
    }
}
