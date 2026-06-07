import SwiftUI

struct AuthFlowView: View {
    @EnvironmentObject private var session: AppSession
    @State private var step: AuthStep = .login

    var body: some View {
        Group {
            switch step {
            case .login:
                LoginView(
                    onSignIn: { move(to: .onboarding) },
                    onCreateAccount: { move(to: .signUp(0)) }
                )
            case .onboarding:
                OnboardingFlowView(onFinished: { move(to: .validation) })
            case .signUp(let index):
                SignUpStepView(
                    stepIndex: index,
                    onBack: { move(to: index == 0 ? .login : .signUp(index - 1)) },
                    onNext: { move(to: index == 2 ? .validation : .signUp(index + 1)) }
                )
            case .validation:
                ValidationView(
                    onBack: { move(to: .onboarding) },
                    onScan: { move(to: .scanID) },
                    onSkip: {
                        session.enterApp()
                    }
                )
            case .scanID:
                ScanIDView(
                    onCancel: { move(to: .validation) },
                    onComplete: { move(to: .verified) }
                )
            case .verified:
                VerifiedPassView {
                    session.finishVerification()
                    session.enterApp()
                }
            }
        }
    }

    private func move(to next: AuthStep) {
        withAnimation(.easeInOut(duration: 0.22)) {
            step = next
        }
    }
}

private enum AuthStep: Equatable {
    case login
    case onboarding
    case signUp(Int)
    case validation
    case scanID
    case verified
}

private struct LoginView: View {
    var onSignIn: () -> Void
    var onCreateAccount: () -> Void

    var body: some View {
        TLVScreen {
            VStack(spacing: 0) {
                Spacer(minLength: 72)

                VStack(spacing: 0) {
                    TLVLogo(size: 88)
                    DisplayText(text: "TLV NIGHTS", size: 44, tracking: 1.2, alignment: .center)
                        .padding(.top, 22)
                    Text("Discover Tel Aviv's underground\nnightlife scene")
                        .font(.system(size: 13))
                        .foregroundColor(TLVTheme.fgMute)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.top, 10)
                }

                VStack(spacing: 12) {
                    TLVInputField(label: "Email", value: "yael@tlv.night")
                    TLVInputField(label: "Password", value: "..........", isSecure: true)
                    HStack {
                        Spacer()
                        Text("Forgot password?")
                            .font(.system(size: 12))
                            .foregroundColor(TLVTheme.fgMute)
                    }
                }
                .padding(.top, 48)

                CTAButton(title: "Sign in", action: onSignIn)
                    .padding(.top, 22)

                DividerWithText(text: "or")
                    .padding(.vertical, 22)

                HStack(spacing: 10) {
                    SocialButton(title: "Google", systemName: "g.circle")
                    SocialButton(title: "Apple", systemName: "apple.logo", dark: true)
                }

                Spacer()

                Button(action: onCreateAccount) {
                    Text("New here? ")
                        .foregroundColor(TLVTheme.fgMute)
                    + Text("Create account")
                        .foregroundColor(TLVTheme.amber)
                        .fontWeight(.semibold)
                }
                .font(.system(size: 13))
                .buttonStyle(.plain)
                .padding(.bottom, 28)
            }
            .padding(.horizontal, 28)
        }
    }
}

private struct DividerWithText: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Rectangle().fill(TLVTheme.line).frame(height: 1)
            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .tracking(1)
                .textCase(.uppercase)
                .foregroundColor(TLVTheme.fgDim)
            Rectangle().fill(TLVTheme.line).frame(height: 1)
        }
    }
}

private struct SocialButton: View {
    let title: String
    let systemName: String
    var dark = false

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: systemName)
                Text(title)
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(TLVTheme.fg)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(dark ? Color.black : TLVTheme.surface)
            .overlay(Capsule().stroke(TLVTheme.lineStrong, lineWidth: 1))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct OnboardingFlowView: View {
    var onFinished: () -> Void
    @State private var page = 0

    var body: some View {
        TLVScreen {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip", action: onFinished)
                        .font(.system(size: 13))
                        .foregroundColor(TLVTheme.fgMute)
                        .buttonStyle(.plain)
                }
                .padding(.horizontal, 28)
                .padding(.top, 20)

                TabView(selection: $page) {
                    ForEach(MockTLVData.onboardingSlides) { slide in
                        OnboardingSlideView(slide: slide)
                            .tag(slide.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 6) {
                    ForEach(0..<MockTLVData.onboardingSlides.count, id: \.self) { index in
                        Capsule()
                            .fill(index == page ? TLVTheme.amber : TLVTheme.fgDim)
                            .frame(width: index == page ? 22 : 4, height: 4)
                    }
                }
                .padding(.bottom, 22)

                CTAButton(title: page == 2 ? "Get started" : "Next") {
                    if page == 2 {
                        onFinished()
                    } else {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            page += 1
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
            }
        }
    }
}

private struct OnboardingSlideView: View {
    let slide: OnboardingSlide

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingIllustration(index: slide.id)
                .frame(height: 320)
                .padding(.top, 24)

            DisplayText(text: slide.title, size: 36)
                .padding(.top, 22)

            Text(slide.body)
                .font(.system(size: 14))
                .foregroundColor(TLVTheme.fgMute)
                .lineSpacing(5)
                .padding(.top, 14)

            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

private struct OnboardingIllustration: View {
    let index: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TLVTheme.radiusXLarge)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: 0x0F0D0B), Color(hex: 0x1A1510)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: TLVTheme.radiusXLarge)
                        .stroke(TLVTheme.line, lineWidth: 1)
                )

            switch index {
            case 0:
                CityIllustration()
            case 1:
                RouteIllustration()
            default:
                FriendsIllustration()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusXLarge))
    }
}

private struct CityIllustration: View {
    var body: some View {
        ZStack {
            RadialGradient(colors: [TLVTheme.amber.opacity(0.22), .clear], center: .topTrailing, startRadius: 0, endRadius: 220)
            Circle()
                .fill(RadialGradient(colors: [TLVTheme.fg, Color(hex: 0xC9B88E)], center: .topLeading, startRadius: 0, endRadius: 56))
                .frame(width: 56, height: 56)
                .shadow(color: TLVTheme.amber.opacity(0.3), radius: 24)
                .offset(x: 96, y: -90)

            VStack {
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach([48, 88, 62, 112, 74, 128, 70, 96, 58], id: \.self) { height in
                        Rectangle()
                            .fill(Color.black.opacity(0.78))
                            .frame(width: 30, height: CGFloat(height))
                    }
                }
                .frame(maxWidth: .infinity)
            }

            Text("OPEN")
                .font(TLVTheme.display(size: 28))
                .fontWidth(.condensed)
                .tracking(2)
                .foregroundColor(TLVTheme.acid)
                .shadow(color: TLVTheme.acid.opacity(0.7), radius: 10)
                .rotationEffect(.degrees(-4))
                .offset(x: -84, y: -38)
        }
    }
}

private struct RouteIllustration: View {
    private let stops = ["MIZNON 20:00", "ARTCLUB 22:00", "SHPAGAT 01:00"]

    var body: some View {
        VStack(spacing: 14) {
            ForEach(stops.indices, id: \.self) { index in
                let text = stops[index]
                HStack(spacing: 12) {
                    Text("\(index + 1)")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(TLVTheme.bg)
                        .frame(width: 24, height: 24)
                        .background(TLVTheme.amber)
                        .clipShape(Circle())
                    DisplayText(text: text, size: 17)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(TLVTheme.amber.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(TLVTheme.amber.opacity(0.25), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(32)
    }
}

private struct FriendsIllustration: View {
    private let nodes: [FriendNode] = [
        FriendNode(initials: "NA", hue: 320, x: -80, y: -72),
        FriendNode(initials: "RO", hue: 140, x: 82, y: -84),
        FriendNode(initials: "IT", hue: 40, x: 18, y: 8),
        FriendNode(initials: "SH", hue: 260, x: -92, y: 78),
        FriendNode(initials: "ET", hue: 60, x: 94, y: 78)
    ]

    var body: some View {
        ZStack {
            RadialGradient(colors: [TLVTheme.amber.opacity(0.18), .clear], center: .center, startRadius: 0, endRadius: 180)
            ForEach(nodes) { node in
                Path { path in
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: node.x, y: node.y))
                }
                .stroke(TLVTheme.amber.opacity(0.35), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            }
            ForEach(nodes) { node in
                AvatarView(initials: node.initials, size: 48, hue: node.hue, ring: true)
                    .offset(x: node.x, y: node.y)
            }
        }
    }
}

private struct FriendNode: Identifiable {
    let initials: String
    let hue: Double
    let x: CGFloat
    let y: CGFloat

    var id: String { initials }
}

private struct SignUpStepView: View {
    let stepIndex: Int
    var onBack: () -> Void
    var onNext: () -> Void

    private var meta: (title: String, hint: String, label: String) {
        switch stepIndex {
        case 0:
            return ("CREATE YOUR ACCOUNT", "We'll send a code to verify your email.", "Continue")
        case 1:
            return ("TELL US ABOUT YOU", "Used for venue age-checks and personalised suggestions.", "Continue")
        default:
            return ("WHAT GETS YOU OUT?", "Pick 3 or more - we'll tune your home feed.", "Create account")
        }
    }

    var body: some View {
        TLVScreen {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    RoundIconButton(systemName: "chevron.left", action: onBack)
                    VStack(alignment: .leading, spacing: 4) {
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                Capsule().fill(TLVTheme.surface)
                                Capsule()
                                    .fill(TLVTheme.amber)
                                    .frame(width: proxy.size.width * CGFloat(stepIndex + 1) / 3)
                            }
                        }
                        .frame(height: 4)
                        Text("STEP \(stepIndex + 1) OF 3 / \(["ACCOUNT", "PROFILE", "TASTES"][stepIndex])")
                            .font(.system(size: 10))
                            .tracking(0.5)
                            .foregroundColor(TLVTheme.fgMute)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                VStack(alignment: .leading, spacing: 0) {
                    DisplayText(text: meta.title, size: 32)
                        .padding(.top, 24)
                    Text(meta.hint)
                        .font(.system(size: 14))
                        .foregroundColor(TLVTheme.fgMute)
                        .lineSpacing(5)
                        .padding(.top, 10)

                    Group {
                        if stepIndex == 0 {
                            VStack(spacing: 12) {
                                TLVInputField(label: "Email", value: "yael@tlv.night")
                                TLVInputField(label: "Password", value: "..........", isSecure: true)
                                TLVInputField(label: "Confirm password", value: "..........", isSecure: true)
                                ConsentRow()
                            }
                        } else if stepIndex == 1 {
                            VStack(spacing: 12) {
                                TLVInputField(label: "First name", value: "Yael")
                                TLVInputField(label: "Last name", value: "Oren")
                                TLVInputField(label: "Date of birth", value: "14 / 06 / 1998")
                                TLVInputField(label: "Phone", value: "+972 54 123 4567")
                            }
                        } else {
                            FlowLayout(spacing: 8) {
                                ForEach(["House", "Techno", "Hip-hop", "Disco", "Jazz", "Live indie", "Mizrahi", "Drum & bass", "Ambient", "Rooftops", "Underground", "Cocktail bars", "Late eats"], id: \.self) { item in
                                    ChipButton(title: item, active: ["House", "Techno", "Hip-hop", "Rooftops", "Underground"].contains(item))
                                }
                            }
                        }
                    }
                    .padding(.top, 22)

                    Spacer()

                    CTAButton(title: meta.label, action: onNext)
                        .padding(.bottom, 28)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct ConsentRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(TLVTheme.bg)
                .frame(width: 18, height: 18)
                .background(TLVTheme.amber)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text("I agree to the Terms and Privacy Policy")
                .font(.system(size: 12))
                .foregroundColor(TLVTheme.fgMute)
                .lineSpacing(4)
            Spacer()
        }
        .padding(12)
        .background(TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
    }
}

private struct ValidationView: View {
    var onBack: () -> Void
    var onScan: () -> Void
    var onSkip: () -> Void
    @State private var selectedMethod = 0

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 12) {
                        RoundIconButton(systemName: "chevron.left", action: onBack)
                        VStack(alignment: .leading, spacing: 4) {
                            Capsule()
                                .fill(TLVTheme.surface)
                                .frame(height: 4)
                                .overlay(alignment: .leading) {
                                    Capsule().fill(TLVTheme.amber).frame(width: 160)
                                }
                            Text("STEP 2 OF 3 / ID CHECK")
                                .font(.system(size: 10))
                                .tracking(0.5)
                                .foregroundColor(TLVTheme.fgMute)
                        }
                    }

                    DisplayText(text: "VERIFY\nYOUR AGE", size: 36)
                        .padding(.top, 24)
                    Text("Many venues require 18+ or 21+. We verify once - venues at the door scan a single TLV pass instead of your physical ID.")
                        .font(.system(size: 14))
                        .foregroundColor(TLVTheme.fgMute)
                        .lineSpacing(5)
                        .padding(.top, 12)

                    VStack(spacing: 10) {
                        MethodCard(index: 0, selectedIndex: $selectedMethod, icon: "person.text.rectangle", title: "Scan ID document", body: "Israeli Teudat Zehut, passport, or driver's license. Encrypted, deleted after 24h.", time: "~30 sec")
                        MethodCard(index: 1, selectedIndex: $selectedMethod, icon: "building.columns", title: "Bank age check", body: "Fast confirmation through a payment provider token. No ID image stored.", time: "~10 sec", badge: "FAST")
                        MethodCard(index: 2, selectedIndex: $selectedMethod, icon: "clock", title: "Manual review", body: "Submit later. Some clubs won't be available until verified.", time: "up to 24h")
                    }
                    .padding(.top, 22)

                    HStack(spacing: 12) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(TLVTheme.success)
                            .frame(width: 36, height: 36)
                            .background(TLVTheme.success.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Encrypted on device")
                                .font(.system(size: 13, weight: .semibold))
                            Text("Auto-deleted after verification / GDPR & ISA compliant")
                                .font(.system(size: 11))
                                .foregroundColor(TLVTheme.fgMute)
                        }
                    }
                    .padding(14)
                    .background(TLVTheme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                            .stroke(TLVTheme.line, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
                    .padding(.top, 18)

                    CTAButton(title: "Continue with ID scan", systemImage: "person.text.rectangle", action: onScan)
                        .padding(.top, 22)

                    Button(action: onSkip) {
                        Text("Skip for now ")
                            .foregroundColor(TLVTheme.fgMute)
                        + Text("/ you can verify later")
                            .foregroundColor(TLVTheme.fgDim)
                    }
                    .font(.system(size: 12))
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 14)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
    }
}

private struct MethodCard: View {
    let index: Int
    @Binding var selectedIndex: Int
    let icon: String
    let title: String
    let body: String
    let time: String
    var badge: String?

    private var selected: Bool { selectedIndex == index }

    var body: some View {
        Button {
            selectedIndex = index
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(TLVTheme.amber)
                    .frame(width: 40, height: 40)
                    .background(TLVTheme.amber.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(TLVTheme.fg)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 9, weight: .black))
                                .tracking(0.5)
                                .foregroundColor(TLVTheme.bg)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(TLVTheme.acid)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                    Text(body)
                        .font(.system(size: 12))
                        .foregroundColor(TLVTheme.fgMute)
                        .lineSpacing(3)
                    Text(time)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(TLVTheme.amber)
                        .padding(.top, 2)
                }

                Spacer()

                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selected ? TLVTheme.amber : TLVTheme.lineStrong)
                    .font(.system(size: 22, weight: .semibold))
            }
            .padding(14)
            .background(selected ? TLVTheme.amber.opacity(0.06) : TLVTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                    .stroke(selected ? TLVTheme.amber : TLVTheme.line, lineWidth: selected ? 1.5 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
        }
        .buttonStyle(.plain)
    }
}

private struct ScanIDView: View {
    var onCancel: () -> Void
    var onComplete: () -> Void
    @State private var ready = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            TLVScreen {
                VStack(spacing: 0) {
                    HStack {
                        RoundIconButton(systemName: "xmark", action: onCancel)
                        Spacer()
                        Text("1 of 2 / Front side")
                            .font(.system(size: 13))
                            .foregroundColor(TLVTheme.fgMute)
                        Spacer()
                        Color.clear.frame(width: 40, height: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    DisplayText(text: "SCAN YOUR ID", size: 26, alignment: .center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    Text("Place your Teudat Zehut inside the frame.\nHold steady - auto-capture in progress.")
                        .font(.system(size: 13))
                        .foregroundColor(TLVTheme.fgMute)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.top, 8)

                    ScanFrame(ready: ready)
                        .padding(.horizontal, 28)
                        .padding(.top, 32)

                    VStack(alignment: .leading, spacing: 0) {
                        CheckLine(ok: true, text: "Document detected")
                        CheckLine(ok: true, text: "Lighting OK")
                        CheckLine(ok: ready, pending: !ready, text: ready ? "Details read" : "Reading details...")
                        CheckLine(ok: ready, text: "Hologram check")
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 24)

                    Spacer()

                    CTAButton(title: ready ? "Complete scan" : "Take photo manually", variant: ready ? .primary : .ghost) {
                        if ready {
                            onComplete()
                        } else {
                            ready = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            ready = true
        }
    }
}

private struct ScanFrame: View {
    let ready: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                .fill(Color(hex: 0x0E0C0A))
                .overlay(DiagonalScanPattern())

            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(colors: [Color(hex: 0x2A2218), Color(hex: 0x3A2E20)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(16)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(TLVTheme.fg.opacity(0.08))
                        .frame(width: 60, height: 76)
                        .padding(.leading, 30)
                }

            Rectangle()
                .fill(ready ? TLVTheme.success : TLVTheme.acid)
                .frame(height: 2)
                .shadow(color: ready ? TLVTheme.success : TLVTheme.acid, radius: 12)
                .offset(y: ready ? 20 : 52)

            CornerBrackets()
                .stroke(TLVTheme.amber, style: StrokeStyle(lineWidth: 3, lineCap: .square))
                .padding(6)
        }
        .aspectRatio(1.586, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
    }
}

private struct DiagonalScanPattern: View {
    var body: some View {
        Canvas { context, size in
            for offset in stride(from: -size.height, through: size.width, by: 12) {
                var path = Path()
                path.move(to: CGPoint(x: offset, y: size.height))
                path.addLine(to: CGPoint(x: offset + size.height, y: 0))
                context.stroke(path, with: .color(Color(hex: 0x16110D)), lineWidth: 6)
            }
        }
    }
}

private struct CornerBrackets: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length: CGFloat = 28
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + length))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + length, y: rect.minY))
        path.move(to: CGPoint(x: rect.maxX - length, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + length))
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - length))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + length, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX - length, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - length))
        return path
    }
}

private struct CheckLine: View {
    var ok = false
    var pending = false
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(pending ? TLVTheme.amber : TLVTheme.fgDim, lineWidth: pending ? 2 : 1.5)
                    .frame(width: 18, height: 18)
                if ok {
                    Circle()
                        .fill(TLVTheme.success)
                        .frame(width: 18, height: 18)
                    Image(systemName: "checkmark")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(TLVTheme.bg)
                }
            }
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(ok ? TLVTheme.fg : pending ? TLVTheme.amber : TLVTheme.fgMute)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

private struct VerifiedPassView: View {
    var onEnter: () -> Void

    var body: some View {
        TLVScreen {
            VStack(spacing: 0) {
                Spacer(minLength: 92)

                ZStack {
                    Circle()
                        .fill(TLVTheme.acid.opacity(0.16))
                        .frame(width: 140, height: 140)
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(TLVTheme.bg)
                        .frame(width: 100, height: 100)
                        .background(TLVTheme.acid)
                        .clipShape(Circle())
                        .shadow(color: TLVTheme.acid.opacity(0.4), radius: 30)
                }

                DisplayText(text: "YOU'RE IN", size: 40, alignment: .center)
                    .padding(.top, 36)

                Text("Verified as Yael Oren / 27\nAll 200+ venues unlocked.")
                    .font(.system(size: 15))
                    .foregroundColor(TLVTheme.fgMute)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.top, 12)

                TLVPassCard()
                    .padding(.top, 32)

                Spacer()

                CTAButton(title: "Enter TLV Nights", action: onEnter)
                    .padding(.bottom, 28)
            }
            .padding(.horizontal, 28)
        }
    }
}

private struct TLVPassCard: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("TLV PASS / 21+")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1.2)
                        .foregroundColor(TLVTheme.amber)
                    DisplayText(text: "YAEL OREN", size: 22)
                    Text("Valid until 26 Apr 2027")
                        .font(.system(size: 11))
                        .foregroundColor(TLVTheme.fgMute)
                }
                Spacer()
                QRPlaceholder()
                    .frame(width: 56, height: 56)
            }
            .padding(18)

            Circle()
                .fill(TLVTheme.amber.opacity(0.08))
                .frame(width: 100, height: 100)
                .offset(x: 28, y: -30)
        }
        .background(
            LinearGradient(colors: [TLVTheme.surfaceHi, TLVTheme.surface], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                .stroke(TLVTheme.amber.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
    }
}

private struct QRPlaceholder: View {
    var body: some View {
        Canvas { context, size in
            var background = Path()
            background.addRect(CGRect(origin: .zero, size: size))
            context.fill(background, with: .color(TLVTheme.fg))

            let cell = size.width / 7
            for row in 0..<7 {
                for col in 0..<7 where (row * 3 + col * 5) % 4 != 0 {
                    let rect = CGRect(x: CGFloat(col) * cell, y: CGFloat(row) * cell, width: cell, height: cell)
                    var cellPath = Path()
                    cellPath.addRect(rect.insetBy(dx: 1, dy: 1))
                    context.fill(cellPath, with: .color(TLVTheme.bg))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct FlowLayout<Content: View>: View {
    var spacing: CGFloat = 8
    private let content: Content

    init(spacing: CGFloat = 8, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 86), spacing: spacing, alignment: .leading)], alignment: .leading, spacing: spacing) {
            content
        }
    }
}
