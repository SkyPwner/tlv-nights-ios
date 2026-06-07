import SwiftUI

struct EventDetailView: View {
    let event: TLVEvent
    @Environment(\.dismiss) private var dismiss
    @State private var added = false
    @State private var liked = true

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    hero
                    content
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            PlaceholderImage(height: 340, hue: event.hue, cornerRadius: 0)
                .overlay(
                    RadialGradient(colors: [TLVTheme.amber.opacity(0.25), .clear], center: .topTrailing, startRadius: 0, endRadius: 280)
                )
                .overlay(
                    LinearGradient(colors: [TLVTheme.bg.opacity(0.18), .clear, TLVTheme.bg.opacity(0.96)], startPoint: .top, endPoint: .bottom)
                )

            HStack {
                RoundIconButton(systemName: "chevron.left") {
                    dismiss()
                }
                Spacer()
                RoundIconButton(systemName: added ? "checkmark" : "plus") {
                    added.toggle()
                }
                RoundIconButton(systemName: liked ? "heart.fill" : "heart", foreground: TLVTheme.coral) {
                    liked.toggle()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 54)
            .frame(maxHeight: .infinity, alignment: .top)

            VStack(alignment: .leading, spacing: 10) {
                if event.live {
                    LiveBadge()
                }
                DisplayText(text: event.title.replacingOccurrences(of: " ", with: "\n", options: [], range: event.title.range(of: "RAP NIGHT")), size: 38)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)

                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(TLVTheme.amber)
                    Text("\(event.venue) / \(event.address)")
                        .font(.system(size: 13))
                        .foregroundColor(TLVTheme.fgMute)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(height: 340)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 8) {
                MetricBox(label: "Start", value: event.startTime)
                MetricBox(label: "End", value: event.endTime)
                MetricBox(label: "Status", value: event.live ? "Live" : "Soon", tone: event.live ? .acid : nil)
                MetricBox(label: "Entry", value: event.entry.replacingOccurrences(of: "NIS ", with: "NIS\n"))
            }

            Text(event.summary)
                .font(.system(size: 14))
                .foregroundColor(TLVTheme.fgMute)
                .lineSpacing(5)

            AntiCard(
                kicker: "Before the show",
                title: "Grab dinner at Miznon / 5 min walk",
                bodyText: "Tables free now. You'll still make doors by 22:00 if you leave by 21:10.",
                actionTitle: added ? "Added to my evening" : "Add to my evening",
                tone: .amber,
                action: { added = true }
            ) {
                EmptyView()
            }

            VStack(spacing: 0) {
                InfoRow(systemName: "music.note", label: "Genre", value: event.genre)
                InfoRow(systemName: "person.2", label: "Average age", value: "22 - 34")
                InfoRow(systemName: "building.2", label: "Venue", value: event.vibe)
                InfoRow(systemName: "tshirt", label: "Dress code", value: "No dress code", isLast: true)
            }
            .background(TLVTheme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                    .stroke(TLVTheme.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))

            friendsGoingCard

            HStack(spacing: 10) {
                CTAButton(title: added ? "Added to my evening" : "Add to my evening", action: { added = true })
                RoundIconButton(systemName: "square.and.arrow.up", size: 50)
            }
            .padding(.top, 4)
            .padding(.bottom, 116)
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    private var friendsGoingCard: some View {
        HStack(spacing: 12) {
            HStack(spacing: -10) {
                AvatarView(initials: "NA", size: 32, hue: 320, ring: true)
                AvatarView(initials: "RO", size: 32, hue: 140, ring: true)
                AvatarView(initials: "IT", size: 32, hue: 40, ring: true)
                AvatarView(initials: "SH", size: 32, hue: 260, ring: true)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(event.friendsGoing + " going")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(TLVTheme.fg)
                Text("2 friends already there")
                    .font(.system(size: 11))
                    .foregroundColor(TLVTheme.fgMute)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(TLVTheme.fgDim)
        }
        .padding(14)
        .background(TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
    }
}
