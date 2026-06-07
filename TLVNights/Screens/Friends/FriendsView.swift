import SwiftUI

struct FriendsView: View {
    @State private var mergedWithNoa = false

    private var goingOut: [TLVFriend] {
        MockTLVData.friends.filter { !$0.isMuted }
    }

    private var allFriends: [TLVFriend] {
        MockTLVData.friends.filter { $0.isMuted }
    }

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        DisplayText(text: "FRIENDS", size: 36)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(TLVTheme.bg)
                                .frame(width: 36, height: 36)
                                .background(TLVTheme.amber)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 14)

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(TLVTheme.fgMute)
                        Text("Search friends")
                            .font(.system(size: 13))
                            .foregroundColor(TLVTheme.fgMute)
                        Spacer()
                    }
                    .frame(height: 42)
                    .padding(.horizontal, 14)
                    .background(TLVTheme.surface)
                    .overlay(Capsule().stroke(TLVTheme.line, lineWidth: 1))
                    .clipShape(Capsule())
                    .padding(.top, 14)

                    AntiCard(kicker: "Nearby now / merge plans?", tone: .amber) {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                AvatarView(initials: "NA", size: 48, hue: 320, ring: true)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Noa is 300m away")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(TLVTheme.fg)
                                    Text("Heading to Kuli Alma / 22:15 / same direction as you")
                                        .font(.system(size: 12))
                                        .foregroundColor(TLVTheme.fgMute)
                                        .lineSpacing(3)
                                }
                                Spacer()
                            }

                            HStack(spacing: 8) {
                                Button {
                                    mergedWithNoa = true
                                } label: {
                                    Text(mergedWithNoa ? "Routes merged" : "Merge our routes")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(TLVTheme.bg)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(TLVTheme.amber)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)

                                Button(action: {}) {
                                    Text("Ping Noa")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(TLVTheme.fg)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .overlay(Capsule().stroke(TLVTheme.lineStrong, lineWidth: 1))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.top, 22)
                    .padding(.bottom, 22)

                    SectionTitle(title: "Going out tonight / 4", actionTitle: "See all ->")
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        ForEach(goingOut) { friend in
                            FriendRow(friend: friend)
                        }
                    }
                    .padding(.bottom, 26)

                    SectionTitle(title: "All friends / 24")
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        ForEach(allFriends) { friend in
                            FriendRow(friend: friend)
                        }
                    }

                    CTAButton(title: "Invite friends to TLV Nights", variant: .ghost, systemImage: "person.badge.plus") {}
                        .padding(.top, 22)
                        .padding(.bottom, 118)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct FriendRow: View {
    let friend: TLVFriend

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                AvatarView(initials: friend.initials, size: 44, hue: friend.hue)
                if !friend.isMuted {
                    Circle()
                        .fill(friend.isLive ? TLVTheme.acid : TLVTheme.success)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(TLVTheme.surface, lineWidth: 2))
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(friend.isMuted ? TLVTheme.fgMute : TLVTheme.fg)
                Text(friend.status)
                    .font(.system(size: 11))
                    .foregroundColor(TLVTheme.fgMute)
                if let destination = friend.destination {
                    HStack(spacing: 4) {
                        if friend.isLive {
                            LiveBadge(small: true)
                        }
                        Text(destination)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(friend.isLive ? TLVTheme.acid : TLVTheme.amber)
                    }
                    .padding(.top, 1)
                }
            }

            Spacer()
        }
        .padding(10)
        .background(TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
    }
}
