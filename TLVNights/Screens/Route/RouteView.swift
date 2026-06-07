import SwiftUI

struct RouteView: View {
    @State private var shared = false
    @State private var addedDessert = false

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("SUN / 20 APRIL / 3 STOPS")
                            .font(.system(size: 12))
                            .tracking(0.5)
                            .foregroundColor(TLVTheme.fgMute)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .padding(.top, 14)

                    DisplayText(text: "MY EVENING", size: 36)
                        .padding(.top, 4)

                    AntiCard(
                        kicker: "Weather-aware / rainy tonight",
                        title: "Rain starts at 21:30",
                        bodyText: "We swapped your original rooftop pick for ArtClub (indoor) and reordered your walk to stay under awnings.",
                        actionTitle: "See changes",
                        tone: .violet
                    ) {
                        EmptyView()
                    }
                    .padding(.top, 18)
                    .padding(.bottom, 20)

                    TimelineView()

                    AntiCard(
                        kicker: "Complete the night / suggested 4th stop",
                        title: "Anita Gelateria / 02:30",
                        bodyText: "You'll be 400m away when Shpagat closes. Open late, matches your Fri-night pattern.",
                        actionTitle: addedDessert ? "Added as stop 4" : "Add as stop 4",
                        tone: .acid,
                        action: { addedDessert = true }
                    ) {
                        EmptyView()
                    }
                    .padding(.leading, 32)
                    .padding(.top, 12)

                    CTAButton(title: "Add stop manually", variant: .ghost, systemImage: "plus") {}
                        .padding(.leading, 32)
                        .padding(.top, 18)

                    SummaryCard()
                        .padding(.top, 22)

                    CTAButton(title: shared ? "Shared with friends" : "Share with friends", systemImage: "square.and.arrow.up") {
                        shared = true
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 118)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct TimelineView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [TLVTheme.amber, TLVTheme.amber, TLVTheme.fgDim],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 2)
                .padding(.leading, 11)
                .padding(.vertical, 12)

            VStack(spacing: 18) {
                ForEach(MockTLVData.eveningStops) { stop in
                    RouteStopCard(stop: stop)
                }
            }
            .padding(.leading, 32)
        }
    }
}

private struct RouteStopCard: View {
    let stop: EveningStop

    private var event: TLVEvent {
        MockTLVData.event(id: stop.eventID)
    }

    private var dotColor: Color {
        switch stop.state {
        case .done: return TLVTheme.amber
        case .now: return TLVTheme.acid
        case .next: return TLVTheme.surface
        }
    }

    var body: some View {
        ZStack(alignment: .leading) {
            dot
                .offset(x: -32 + 4, y: -24)

            NavigationLink(value: AppRoute.eventDetail(stop.eventID)) {
                HStack(spacing: 12) {
                    PlaceholderImage(height: 56, hue: event.hue, cornerRadius: 10)
                        .frame(width: 56)

                    VStack(alignment: .leading, spacing: 3) {
                        DisplayText(text: stop.time, size: 14, color: stop.state == .now ? TLVTheme.acid : TLVTheme.amber)
                        HStack(spacing: 6) {
                            Text(stop.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(TLVTheme.fg)
                            if stop.state == .now {
                                LiveBadge(small: true)
                            }
                        }
                        Text(stop.kind)
                            .font(.system(size: 11))
                            .foregroundColor(TLVTheme.fgMute)
                        Text(stop.meta)
                            .font(.system(size: 11))
                            .foregroundColor(stop.state == .now ? TLVTheme.acid : TLVTheme.fgDim)
                            .padding(.top, 1)
                    }
                    Spacer()
                }
                .padding(12)
                .background(stop.state == .now ? TLVTheme.acid.opacity(0.05) : TLVTheme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                        .stroke(stop.state == .now ? TLVTheme.acid.opacity(0.3) : TLVTheme.line, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
            }
            .buttonStyle(.plain)
        }
    }

    private var dot: some View {
        ZStack {
            Circle()
                .fill(dotColor)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(stop.state == .next ? TLVTheme.fgDim : dotColor, lineWidth: 2)
                )
                .shadow(color: stop.state == .now ? TLVTheme.acid.opacity(0.45) : .clear, radius: 10)
            if stop.state == .done {
                Image(systemName: "checkmark")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(TLVTheme.bg)
            }
        }
    }
}

private struct SummaryCard: View {
    var body: some View {
        HStack(spacing: 8) {
            SummaryItem(label: "Walking", value: "18 min")
            SummaryItem(label: "Est. cost", value: "NIS 180")
            SummaryItem(label: "Duration", value: "6 h")
        }
        .padding(16)
        .background(TLVTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
    }
}

private struct SummaryItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .tracking(0.8)
                .textCase(.uppercase)
                .foregroundColor(TLVTheme.fgDim)
            DisplayText(text: value, size: 22)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
