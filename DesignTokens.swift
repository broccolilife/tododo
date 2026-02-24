import SwiftUI

// MARK: - Design Tokens
// Single source of truth for all visual constants.
// Every view references DS.* — no magic numbers in view code.

enum DS {
    // MARK: Spacing (8pt grid)
    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let section: CGFloat = 28
    }

    // MARK: Corner Radius
    enum Radius {
        static let sm: CGFloat = 12
        static let md: CGFloat = 20
        static let lg: CGFloat = 24
        static let xl: CGFloat = 28
        static let xxl: CGFloat = 32
        static let pill: CGFloat = 36
    }

    // MARK: Animation
    enum Animation {
        static let springResponse: CGFloat = 0.45
        static let springDamping: CGFloat = 0.8
        static let bouncyResponse: CGFloat = 0.35
        static let bouncyDamping: CGFloat = 0.65

        static var standard: SwiftUI.Animation {
            .spring(response: springResponse, dampingFraction: springDamping)
        }
        static var bouncy: SwiftUI.Animation {
            .spring(response: bouncyResponse, dampingFraction: bouncyDamping)
        }
        static var gentle: SwiftUI.Animation {
            .spring(response: 0.5, dampingFraction: 0.82)
        }
    }

    // MARK: Shadows
    enum Shadow {
        static let cardRadius: CGFloat = 20
        static let cardOpacity: Double = 0.3
        static let cardY: CGFloat = 10
        static let floatingRadius: CGFloat = 16
        static let floatingOpacity: Double = 0.28
        static let floatingY: CGFloat = 8
    }

    // MARK: Sizing
    enum Size {
        static let orbDiameter: CGFloat = 72
        static let categoryTrayHeight: CGFloat = 112
        static let fabPadding: CGFloat = 24
        static let dragHandle = CGSize(width: 48, height: 6)
    }
}
