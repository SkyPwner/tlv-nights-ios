import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    header

                    SectionTitle(title: "Preferences")
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        .padding(.bottom, 12)

                    VStack(spacing: 0) {
                        ProfileRow(label: "Music tastes") {
                            HStack(spacing: 6) {
                                MiniTag("House")
                                MiniTag("Rap")
                                MiniTag("+3")
                            }
                        }
                        ProfileRow(label: "Favorite venues") {
                            Text("Shpagat, Kuli Alma, Port Said")
                                .font(.system(size: 13))
                                .foregroundColor(TLVTheme.fg)
                                .lineLimit(1)
                        }
                        NavigationLink(value: AppRoute.notifications) {
                            ProfileRow(label: "Notifications") {
                                Text("Smart / 12 rules")
                                    .font(.system(size: 13))
                                    .foregroundColor(TLVTheme.fg)
                            }
                        }
                        .buttonStyle(.plain)
                        ProfileRow(label: "Go-out budget", isLast: true) {
                            Text("NIS 150-300 / night")
                                .font(.system(size: 13))
                                .foregroundColor(TLVTheme.fg)
                        }
                    }
                    .background(TLVTheme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                            .stroke(TLVTheme.line, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    SectionTitle(title: "Account")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    VStack(spacing: 0) {
                        ProfileRow(label: "Edit profile") { EmptyView() }
                        ProfileRow(label: "Settings") { EmptyView() }
                        ProfileRow(label: "Help & privacy") { EmptyView() }
                        Button {
                            session.logOut()
                        } label: {
                            ProfileRow(label: "Log out", isLast: true, danger: true) { EmptyView() }
                        }
                        .buttonStyle(.plain)
                    }
                    .background(TLVTheme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                            .stroke(TLVTheme.line, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 118)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                AvatarView(initials: "YO", size: 84, hue: 30, ring: true)
                Spacer()
                Button(action: {}) {
                    Text("Edit")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(TLVTheme.fg)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .overlay(Capsule().stroke(TLVTheme.lineStrong, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }

            DisplayText(text: "YAEL OREN", size: 34)
                .padding(.top, 16)
            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(TLVTheme.amber)
                Text("Florentin, Tel Aviv / Joined Mar 2024")
                    .font(.system(size: 13))
                    .foregroundColor(TLVTheme.fgMute)
            }
            .padding(.top, 4)

            HStack(spacing: 0) {
                ProfileStat(label: "Evenings", value: "47")
                Divider().background(TLVTheme.line).padding(.vertical, 4)
                ProfileStat(label: "Events", value: "132")
                Divider().background(TLVTheme.line).padding(.vertical, 4)
                ProfileStat(label: "Friends", value: "24")
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 24)
        .background(
            RadialGradient(colors: [TLVTheme.amber.opacity(0.18), .clear], center: .topLeading, startRadius: 0, endRadius: 260)
        )
    }
}

private struct ProfileStat: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            DisplayText(text: value, size: 30, alignment: .center)
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .tracking(0.8)
                .textCase(.uppercase)
                .foregroundColor(TLVTheme.fgMute)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProfileRow<Content: View>: View {
    let label: String
    var isLast = false
    var danger = false
    private let content: Content

    init(label: String, isLast: Bool = false, danger: Bool = false, @ViewBuilder content: () -> Content) {
        self.label = label
        self.isLast = isLast
        self.danger = danger
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(size: 14, weight: danger ? .semibold : .medium))
                .foregroundColor(danger ? TLVTheme.coral : TLVTheme.fg)
            Spacer()
            content
            if !danger {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(TLVTheme.fgDim)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle().fill(TLVTheme.line).frame(height: 1)
            }
        }
    }
}

private struct MiniTag: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(TLVTheme.amber)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(TLVTheme.amber.opacity(0.15))
            .clipShape(Capsule())
    }
}
