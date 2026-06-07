import SwiftUI

struct NotificationsView: View {
    private var unread: [InboxNotification] {
        MockTLVData.notifications.filter { $0.unread }
    }

    private var earlier: [InboxNotification] {
        MockTLVData.notifications.filter { !$0.unread }
    }

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .bottom) {
                        DisplayText(text: "INBOX", size: 36)
                        Spacer()
                        Button("Mark all read") {}
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(TLVTheme.amber)
                            .buttonStyle(.plain)
                            .padding(.bottom, 6)
                    }
                    .padding(.top, 14)

                    Text("3 new / tonight")
                        .font(.system(size: 12))
                        .foregroundColor(TLVTheme.fgMute)
                        .padding(.top, 4)

                    NotificationGroup(label: "New", notifications: unread)
                        .padding(.top, 26)

                    NotificationGroup(label: "Earlier today", notifications: earlier)
                        .padding(.top, 20)
                        .padding(.bottom, 118)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct NotificationGroup: View {
    let label: String
    let notifications: [InboxNotification]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundColor(TLVTheme.fgMute)

            VStack(spacing: 8) {
                ForEach(notifications) { notification in
                    NotificationRow(notification: notification)
                }
            }
        }
    }
}

private struct NotificationRow: View {
    let notification: InboxNotification

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let initials = notification.friendInitials {
                AvatarView(initials: initials, size: 40, hue: notification.friendHue ?? 30)
            } else {
                NotificationIcon(kind: notification.kind)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .top, spacing: 8) {
                    Text(notification.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(TLVTheme.fg)
                        .lineSpacing(2)
                    Spacer()
                    Text(notification.time)
                        .font(.system(size: 10))
                        .foregroundColor(TLVTheme.fgDim)
                        .fixedSize()
                }

                Text(notification.body)
                    .font(.system(size: 12))
                    .foregroundColor(TLVTheme.fgMute)
                    .lineSpacing(4)
            }
        }
        .padding(12)
        .background(notification.unread ? TLVTheme.amber.opacity(0.05) : TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                .stroke(notification.unread ? TLVTheme.amber.opacity(0.25) : TLVTheme.line, lineWidth: 1)
        )
        .overlay(alignment: .leading) {
            if notification.unread {
                Capsule()
                    .fill(TLVTheme.amber)
                    .frame(width: 4, height: 28)
                    .offset(x: -4)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
    }
}

private struct NotificationIcon: View {
    let kind: NotificationKind

    private var color: Color {
        switch kind {
        case .route: return TLVTheme.amber
        case .friend: return TLVTheme.coral
        case .venue: return TLVTheme.acid
        case .event: return TLVTheme.violet
        case .confirm: return TLVTheme.success
        }
    }

    private var symbol: String {
        switch kind {
        case .route: return "figure.walk.motion"
        case .friend: return "person.2"
        case .venue: return "building.2"
        case .event: return "clock"
        case .confirm: return "checkmark.circle"
        }
    }

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(color)
            .frame(width: 40, height: 40)
            .background(color.opacity(0.14))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
