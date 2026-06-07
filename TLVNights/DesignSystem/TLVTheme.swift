import SwiftUI

enum TLVTheme {
    static let bg = Color(hex: 0x0A0908)
    static let surface = Color(hex: 0x141210)
    static let surfaceHi = Color(hex: 0x1C1917)
    static let fg = Color(hex: 0xF5EEDC)
    static let amber = Color(hex: 0xE8A23C)
    static let acid = Color(hex: 0xD9FF00)
    static let coral = Color(hex: 0xFF6B5C)
    static let violet = Color(hex: 0x9B8CFF)
    static let blue = Color(hex: 0x4FC3FF)
    static let success = Color(hex: 0x66DD88)

    static let fgMute = fg.opacity(0.62)
    static let fgDim = fg.opacity(0.38)
    static let line = fg.opacity(0.08)
    static let lineStrong = fg.opacity(0.14)

    static let radiusSmall: CGFloat = 10
    static let radiusMedium: CGFloat = 16
    static let radiusLarge: CGFloat = 20
    static let radiusXLarge: CGFloat = 28

    static func display(size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .default)
    }

    static func body(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

enum TLVTone {
    case amber
    case acid
    case violet
    case coral
    case success

    var color: Color {
        switch self {
        case .amber: return TLVTheme.amber
        case .acid: return TLVTheme.acid
        case .violet: return TLVTheme.violet
        case .coral: return TLVTheme.coral
        case .success: return TLVTheme.success
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

struct TLVBackground: View {
    var body: some View {
        ZStack {
            TLVTheme.bg
            RadialGradient(
                colors: [TLVTheme.amber.opacity(0.12), .clear],
                center: .topTrailing,
                startRadius: 10,
                endRadius: 420
            )
            RadialGradient(
                colors: [TLVTheme.acid.opacity(0.05), .clear],
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 360
            )
            NoiseOverlay()
                .opacity(0.08)
                .blendMode(.overlay)
        }
        .ignoresSafeArea()
    }
}

private struct NoiseOverlay: View {
    var body: some View {
        Canvas { context, size in
            for index in 0..<260 {
                let x = CGFloat((index * 73) % 997) / 997 * size.width
                let y = CGFloat((index * 41) % 991) / 991 * size.height
                let opacity = Double(((index * 19) % 10) + 2) / 30
                let rect = CGRect(x: x, y: y, width: 1.2, height: 1.2)
                context.fill(Path(ellipseIn: rect), with: .color(TLVTheme.fg.opacity(opacity)))
            }
        }
        .allowsHitTesting(false)
    }
}

struct TLVScreen<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            TLVBackground()
            content
        }
        .foregroundColor(TLVTheme.fg)
        .toolbar(.hidden, for: .navigationBar)
    }
}
