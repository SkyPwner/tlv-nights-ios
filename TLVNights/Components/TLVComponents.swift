import SwiftUI

struct DisplayText: View {
    let text: String
    var size: CGFloat = 30
    var color: Color = TLVTheme.fg
    var tracking: CGFloat = 1.0
    var alignment: TextAlignment = .leading

    var body: some View {
        Text(text)
            .font(TLVTheme.display(size: size))
            .fontWidth(.condensed)
            .tracking(tracking)
            .lineSpacing(-2)
            .multilineTextAlignment(alignment)
            .foregroundColor(color)
    }
}

struct TLVLogo: View {
    var size: CGFloat = 76
    var accent: Color = TLVTheme.amber

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [accent.opacity(0.18), TLVTheme.surface.opacity(0.2)],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size
                    )
                )
                .overlay(Circle().stroke(accent, lineWidth: 1.5))

            Circle()
                .stroke(accent.opacity(0.35), lineWidth: 1)
                .padding(5)

            Text("TLV")
                .font(TLVTheme.display(size: size * 0.36))
                .fontWidth(.condensed)
                .tracking(1)
                .foregroundColor(accent)
        }
        .frame(width: size, height: size)
    }
}

struct AvatarView: View {
    var initials: String
    var size: CGFloat = 36
    var hue: Double = 30
    var ring = false

    var body: some View {
        Text(initials)
            .font(.system(size: size * 0.36, weight: .semibold))
            .tracking(-0.3)
            .foregroundColor(Color(hue: hue / 360, saturation: 0.18, brightness: 0.96))
            .frame(width: size, height: size)
            .background(Color(hue: hue / 360, saturation: 0.35, brightness: 0.42))
            .clipShape(Circle())
            .overlay {
                if ring {
                    Circle()
                        .stroke(TLVTheme.bg, lineWidth: 4)
                        .overlay(Circle().stroke(TLVTheme.amber, lineWidth: 1.5))
                }
            }
    }
}

enum CTAButtonVariant {
    case primary
    case ghost
}

struct CTAButton: View {
    let title: String
    var variant: CTAButtonVariant = .primary
    var systemImage: String?
    var isBlock = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 14, weight: .bold))
                }
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .tracking(0.2)
            }
            .foregroundColor(variant == .primary ? TLVTheme.bg : TLVTheme.fg)
            .frame(maxWidth: isBlock ? .infinity : nil)
            .frame(minHeight: 50)
            .padding(.horizontal, 20)
            .background(variant == .primary ? TLVTheme.amber : Color.clear)
            .overlay {
                if variant == .ghost {
                    Capsule().stroke(TLVTheme.lineStrong, lineWidth: 1)
                }
            }
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct ChipButton: View {
    let title: String
    var active = false
    var compact = true
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: compact ? 13 : 14, weight: .medium))
                .foregroundColor(active ? TLVTheme.bg : TLVTheme.fg)
                .lineLimit(1)
                .padding(.horizontal, compact ? 10 : 14)
                .padding(.vertical, compact ? 7 : 9)
                .background(active ? TLVTheme.fg : Color.clear)
                .overlay(Capsule().stroke(active ? TLVTheme.fg : TLVTheme.lineStrong, lineWidth: 1))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct LiveBadge: View {
    var small = false
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(TLVTheme.bg.opacity(0.25))
                    .frame(width: small ? 5 : 6, height: small ? 5 : 6)
                    .scaleEffect(pulse ? 2.2 : 1)
                    .opacity(pulse ? 0 : 0.75)

                Circle()
                    .fill(TLVTheme.bg)
                    .frame(width: small ? 5 : 6, height: small ? 5 : 6)
            }

            Text("LIVE")
                .font(.system(size: small ? 9 : 10, weight: .black))
                .tracking(0.8)
        }
        .foregroundColor(TLVTheme.bg)
        .padding(.horizontal, small ? 7 : 9)
        .padding(.vertical, small ? 3 : 4)
        .background(TLVTheme.acid)
        .clipShape(Capsule())
        .onAppear {
            withAnimation(.easeOut(duration: 1.35).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
    }
}

struct AntiCard<Content: View>: View {
    let kicker: String
    var title: String?
    var bodyText: String?
    var actionTitle: String?
    var tone: TLVTone = .amber
    var action: (() -> Void)?
    private let content: Content

    init(
        kicker: String,
        title: String? = nil,
        bodyText: String? = nil,
        actionTitle: String? = nil,
        tone: TLVTone = .amber,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.kicker = kicker
        self.title = title
        self.bodyText = bodyText
        self.actionTitle = actionTitle
        self.tone = tone
        self.action = action
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "sparkle")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(tone.color)
                Text(kicker)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .textCase(.uppercase)
                    .foregroundColor(tone.color)
            }
            .padding(.bottom, 10)

            if let title {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(TLVTheme.fg)
                    .lineSpacing(2)
                    .padding(.bottom, bodyText == nil ? 0 : 6)
            }

            if let bodyText {
                Text(bodyText)
                    .font(.system(size: 13))
                    .foregroundColor(TLVTheme.fgMute)
                    .lineSpacing(3)
                    .padding(.bottom, actionTitle == nil ? 0 : 12)
            }

            content

            if let actionTitle {
                Button(action: { action?() }) {
                    Text(actionTitle + " ->")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(tone.color)
                        .padding(.top, 12)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [TLVTheme.surfaceHi, TLVTheme.surface],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .topLeading) {
            Rectangle()
                .fill(tone.color)
                .frame(width: 3, height: 32)
        }
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
    }
}

struct SectionTitle: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.4)
                .textCase(.uppercase)
                .foregroundColor(TLVTheme.fgMute)
            Spacer()
            if let actionTitle {
                Button(action: { action?() }) {
                    Text(actionTitle)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(TLVTheme.amber)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct PlaceholderImage: View {
    var height: CGFloat = 140
    var hue: Double = 30
    var label: String = ""
    var cornerRadius: CGFloat = TLVTheme.radiusMedium

    var body: some View {
        ZStack {
            Color(hue: hue / 360, saturation: 0.28, brightness: 0.18)
            DiagonalStripeOverlay(hue: hue)
            if !label.isEmpty {
                Text(label)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .tracking(0.5)
                    .textCase(.uppercase)
                    .foregroundColor(TLVTheme.fgMute)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(TLVTheme.bg.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

private struct DiagonalStripeOverlay: View {
    var hue: Double

    var body: some View {
        Canvas { context, size in
            let color = Color(hue: hue / 360, saturation: 0.25, brightness: 0.24).opacity(0.75)
            for offset in stride(from: -size.height, through: size.width, by: 16) {
                var path = Path()
                path.move(to: CGPoint(x: offset, y: size.height))
                path.addLine(to: CGPoint(x: offset + size.height, y: 0))
                context.stroke(path, with: .color(color), lineWidth: 8)
            }
        }
    }
}

struct RoundIconButton: View {
    var systemName: String
    var size: CGFloat = 40
    var background: Color = TLVTheme.bg.opacity(0.62)
    var foreground: Color = TLVTheme.fg
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: size * 0.38, weight: .bold))
                .foregroundColor(foreground)
                .frame(width: size, height: size)
                .background(background)
                .overlay(Circle().stroke(TLVTheme.lineStrong, lineWidth: 1))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct TLVInputField: View {
    let label: String
    let value: String
    var isSecure = false
    var isError = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1)
                    .textCase(.uppercase)
                    .foregroundColor(isError ? TLVTheme.coral : TLVTheme.fgDim)
                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(TLVTheme.fg)
                    .tracking(0.2)
            }
            Spacer()
            if isSecure {
                Image(systemName: isError ? "exclamationmark.circle" : "eye")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isError ? TLVTheme.coral : TLVTheme.fgMute)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isError ? TLVTheme.coral.opacity(0.06) : TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                .stroke(isError ? TLVTheme.coral : TLVTheme.line, lineWidth: isError ? 1.5 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
    }
}

struct MetricBox: View {
    let label: String
    let value: String
    var tone: TLVTone?

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .tracking(0.8)
                .textCase(.uppercase)
                .foregroundColor(TLVTheme.fgDim)
            DisplayText(text: value, size: 20, color: tone?.color ?? TLVTheme.fg, tracking: 0.5, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InfoRow: View {
    var systemName: String
    var label: String
    var value: String
    var isLast = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemName)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(TLVTheme.amber)
                .frame(width: 20)
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(TLVTheme.fgMute)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(TLVTheme.fg)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(TLVTheme.line)
                    .frame(height: 1)
                    .padding(.leading, 48)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
