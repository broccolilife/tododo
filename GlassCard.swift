import SwiftUI

/// Reusable glassmorphic card container using Apple's Liquid Glass API (`.glassEffect`).
/// Wraps arbitrary content with rounded corners, a subtle gradient border, and drop shadow.
struct GlassCard<Content: View>: View {
    var tint: Color
    @ViewBuilder var content: Content

    @State private var isPressed = false

    init(tint: Color, @ViewBuilder content: () -> Content) {
        self.tint = tint
        self.content = content()
    }

    var body: some View {
        content
            .padding(Tokens.Spacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .tint(tint)
            .background(
                RoundedRectangle(cornerRadius: Tokens.Radius.lg, style: .continuous)
                    .fill(.clear)
                    // Crystal clear Apple Liquid Glass card surface
                    .glassEffect(
                        .clear
                            .interactive(),
                        in: .rect(cornerRadius: Tokens.Radius.lg)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Tokens.Radius.lg, style: .continuous)
                            .strokeBorder(
                                .linearGradient(
                                    colors: [
                                        Color.white.opacity(Tokens.Border.glassHighOpacity),
                                        Color.white.opacity(Tokens.Border.glassMidOpacity),
                                        Color.white.opacity(Tokens.Border.glassLowOpacity)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: Tokens.Border.glassWidth
                            )
                            .blendMode(.plusLighter)
                    )
            )
            .shadow(color: .black.opacity(Tokens.Shadow.cardOpacity), radius: Tokens.Shadow.cardRadius, x: 0, y: Tokens.Shadow.cardY)
            // Smooth liquid-like animations for state changes
            .animation(Tokens.Spring.liquid, value: isPressed)
    }
}

#Preview {
    GlassCard(tint: Palette.color(for: "Calm")) {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview Task")
                .font(.headline)
            Text("This is a glass card preview.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    .padding()
    .background(Color.black)
}
