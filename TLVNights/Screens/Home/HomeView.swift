import SwiftUI

struct HomeView: View {
    var onOpenFilters: () -> Void
    var onSelectTab: (AppTab) -> Void

    @State private var selectedDate = 0
    @State private var selectedChip = "Tonight"

    private let dateOptions = [
        ("Tonight", "Sun 20"),
        ("Mon", "21"),
        ("Tue", "22"),
        ("Wed", "23"),
        ("Thu", "24"),
        ("Fri", "25")
    ]

    private let feedEvents = Array(MockTLVData.events.prefix(5))

    var body: some View {
        TLVScreen {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                        .padding(.top, 12)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sunday, 20 April / 18:42")
                            .font(.system(size: 12))
                            .tracking(0.5)
                            .foregroundColor(TLVTheme.fgMute)
                        DisplayText(text: "GOOD EVENING, YAEL", size: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 14)

                    dateSelector
                        .padding(.bottom, 14)

                    filterChips
                        .padding(.bottom, 14)

                    tonightPlanCard
                        .padding(.horizontal, 20)
                        .padding(.bottom, 18)

                    SectionTitle(title: "Happening around you", actionTitle: "Full map ->") {
                        onSelectTab(.map)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)

                    MiniMapPreview()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 18)
                        .onTapGesture { onSelectTab(.map) }

                    SectionTitle(title: "Featured tonight")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    featuredEvent
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)

                    SectionTitle(title: "More tonight")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)

                    VStack(spacing: 10) {
                        ForEach(feedEvents.dropFirst()) { event in
                            NavigationLink(value: AppRoute.eventDetail(event.id)) {
                                EventRowCard(event: event)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 118)
                }
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            AvatarView(initials: "YO", size: 36, hue: 40)

            NavigationLink(value: AppRoute.search) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(TLVTheme.fgMute)
                    Text("Search events, venues, djs")
                        .font(.system(size: 13))
                        .foregroundColor(TLVTheme.fgMute)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .frame(height: 40)
                .background(TLVTheme.surface)
                .overlay(Capsule().stroke(TLVTheme.line, lineWidth: 1))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            NavigationLink(value: AppRoute.notifications) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(TLVTheme.fg)
                    Circle()
                        .fill(TLVTheme.coral)
                        .frame(width: 8, height: 8)
                        .overlay(Circle().stroke(TLVTheme.bg, lineWidth: 2))
                        .offset(x: 2, y: -2)
                }
                .frame(width: 28, height: 40)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }

    private var dateSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(dateOptions.indices, id: \.self) { index in
                    let item = dateOptions[index]
                    Button {
                        selectedDate = index
                    } label: {
                        VStack(spacing: 2) {
                            Text(item.0)
                                .font(.system(size: 10, weight: .bold))
                                .tracking(0.6)
                                .textCase(.uppercase)
                                .opacity(selectedDate == index ? 0.7 : 0.55)
                            Text(item.1)
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(selectedDate == index ? TLVTheme.bg : TLVTheme.fg)
                        .frame(minWidth: 56)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(selectedDate == index ? TLVTheme.amber : TLVTheme.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(selectedDate == index ? TLVTheme.amber : TLVTheme.line, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(["Tonight", "This weekend", "Nearby"], id: \.self) { chip in
                    ChipButton(title: chip, active: selectedChip == chip) {
                        selectedChip = chip
                    }
                }

                Button(action: onOpenFilters) {
                    HStack(spacing: 6) {
                        Image(systemName: "line.3.horizontal.decrease")
                        Text("Filters")
                        Text("3")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(TLVTheme.bg)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(TLVTheme.amber)
                            .clipShape(Capsule())
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(TLVTheme.amber)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(TLVTheme.amber.opacity(0.12))
                    .overlay(Capsule().stroke(TLVTheme.amber, lineWidth: 1))
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
        }
    }

    private var tonightPlanCard: some View {
        AntiCard(kicker: "Tonight's plan / built for you", tone: .amber) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    DisplayText(text: "YOUR EVENING", size: 20)
                    Text("20:00 - 02:00 / 3 stops")
                        .font(.system(size: 11))
                        .foregroundColor(TLVTheme.fgMute)
                }

                HStack(spacing: 6) {
                    ForEach(MockTLVData.eveningStops.indices, id: \.self) { index in
                        let stop = MockTLVData.eveningStops[index]
                        VStack(spacing: 3) {
                            Text(stop.time)
                                .font(.system(size: 9, weight: .bold))
                                .tracking(0.6)
                                .foregroundColor(TLVTheme.amber)
                            Text(stop.name)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(TLVTheme.fg)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .background(TLVTheme.amber.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(TLVTheme.amber.opacity(0.2), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        if index < MockTLVData.eveningStops.count - 1 {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(TLVTheme.amber)
                        }
                    }
                }

                HStack {
                    Text("~18 min walking / NIS 180 avg")
                        .font(.system(size: 11))
                        .foregroundColor(TLVTheme.fgMute)
                    Spacer()
                    Button {
                        onSelectTab(.route)
                    } label: {
                        Text("Open route ->")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(TLVTheme.bg)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(TLVTheme.amber)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 2)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(TLVTheme.line)
                        .frame(height: 1)
                        .offset(y: -8)
                }
            }
        }
    }

    private var featuredEvent: some View {
        NavigationLink(value: AppRoute.eventDetail(MockTLVData.events[0].id)) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    PlaceholderImage(height: 140, hue: MockTLVData.events[0].hue, label: "event hero", cornerRadius: 0)
                    LiveBadge()
                        .padding(12)
                    Text(MockTLVData.events[0].venue + " / " + MockTLVData.events[0].distance)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(TLVTheme.fg)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(TLVTheme.bg.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(12)
                }
                VStack(alignment: .leading, spacing: 4) {
                    DisplayText(text: MockTLVData.events[0].title, size: 20)
                    Text("Open now / Until \(MockTLVData.events[0].endTime) / \(MockTLVData.events[0].entry) at the door")
                        .font(.system(size: 12))
                        .foregroundColor(TLVTheme.fgMute)
                }
                .padding(14)
            }
            .background(TLVTheme.surfaceHi)
            .overlay(
                RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                    .stroke(TLVTheme.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
        }
        .buttonStyle(.plain)
    }
}

struct EventRowCard: View {
    let event: TLVEvent

    var body: some View {
        HStack(spacing: 12) {
            PlaceholderImage(height: 56, hue: event.hue, cornerRadius: 10)
                .frame(width: 56)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(event.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(TLVTheme.fg)
                        .lineLimit(1)
                    if event.live {
                        LiveBadge(small: true)
                    }
                }
                Text(event.venue)
                    .font(.system(size: 12))
                    .foregroundColor(TLVTheme.fgMute)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 0) {
                DisplayText(text: event.startTime, size: 18, color: TLVTheme.amber, tracking: 0.5, alignment: .trailing)
                Text("START")
                    .font(.system(size: 10))
                    .foregroundColor(TLVTheme.fgDim)
            }
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

private struct MiniMapPreview: View {
    private let pins: [(CGFloat, CGFloat, Color)] = [
        (0.40, 0.35, TLVTheme.amber),
        (0.62, 0.55, TLVTheme.amber),
        (0.78, 0.28, TLVTheme.acid),
        (0.30, 0.70, TLVTheme.amber),
        (0.50, 0.82, TLVTheme.coral),
        (0.82, 0.75, TLVTheme.amber)
    ]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(colors: [Color(hex: 0x100D0A), Color(hex: 0x1A1510)], startPoint: .topLeading, endPoint: .bottomTrailing)
                MapGrid()

                ForEach(pins.indices, id: \.self) { index in
                    let pin = pins[index]
                    Circle()
                        .fill(pin.2)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(TLVTheme.bg, lineWidth: 2))
                        .shadow(color: pin.2.opacity(0.7), radius: 10)
                        .position(x: pin.0 * proxy.size.width, y: pin.1 * proxy.size.height)
                }

                Circle()
                    .fill(TLVTheme.blue)
                    .frame(width: 14, height: 14)
                    .overlay(Circle().stroke(TLVTheme.bg, lineWidth: 2))
                    .shadow(color: TLVTheme.blue.opacity(0.4), radius: 10)
                    .position(x: 0.55 * proxy.size.width, y: 0.55 * proxy.size.height)

                Text("Florentin / 6 venues live")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(0.5)
                    .textCase(.uppercase)
                    .foregroundColor(TLVTheme.fg)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(TLVTheme.bg.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(10)
            }
        }
        .frame(height: 150)
        .overlay(
            RoundedRectangle(cornerRadius: TLVTheme.radiusMedium)
                .stroke(TLVTheme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusMedium))
    }
}

struct MapGrid: View {
    var body: some View {
        Canvas { context, size in
            for y in stride(from: CGFloat(20), through: size.height, by: 30) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(TLVTheme.fg.opacity(0.05)), lineWidth: 1)
            }
            for x in stride(from: CGFloat(30), through: size.width, by: 40) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(TLVTheme.fg.opacity(0.05)), lineWidth: 1)
            }
            var street = Path()
            street.move(to: CGPoint(x: 0, y: size.height * 0.55))
            street.addLine(to: CGPoint(x: size.width, y: size.height * 0.55))
            street.move(to: CGPoint(x: size.width * 0.45, y: 0))
            street.addLine(to: CGPoint(x: size.width * 0.45, y: size.height))
            context.stroke(street, with: .color(TLVTheme.fg.opacity(0.12)), lineWidth: 1.5)
        }
    }
}
