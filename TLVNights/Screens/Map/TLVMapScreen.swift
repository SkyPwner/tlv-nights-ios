import MapKit
import SwiftUI

struct TLVMapScreen: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.0646, longitude: 34.7738),
        span: MKCoordinateSpan(latitudeDelta: 0.018, longitudeDelta: 0.018)
    )
    @State private var selectedEventID = "kitchen-sessions"
    @State private var selectedCategory = "All"

    private var selectedEvent: TLVEvent {
        MockTLVData.event(id: selectedEventID)
    }

    private var annotations: [MapPinItem] {
        MockTLVData.events.map { event in
            MapPinItem(
                id: event.id,
                title: event.venue,
                eventID: event.id,
                latitude: event.latitude,
                longitude: event.longitude,
                color: event.live ? TLVTheme.acid : TLVTheme.amber,
                isUser: false
            )
        } + [
            MapPinItem(
                id: "you-are-here",
                title: "You",
                eventID: nil,
                latitude: 32.0641,
                longitude: 34.7748,
                color: TLVTheme.blue,
                isUser: true
            )
        ]
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, annotationItems: annotations) { item in
                MapAnnotation(coordinate: item.coordinate, anchorPoint: CGPoint(x: 0.5, y: item.isUser ? 0.5 : 1.0)) {
                    if item.isUser {
                        UserLocationDot()
                    } else {
                        EventPin(
                            title: item.title,
                            color: item.color,
                            selected: item.eventID == selectedEventID
                        ) {
                            if let eventID = item.eventID {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                                    selectedEventID = eventID
                                    region.center = item.coordinate
                                }
                            }
                        }
                    }
                }
            }
            .colorScheme(.dark)
            .ignoresSafeArea()

            LinearGradient(colors: [TLVTheme.bg.opacity(0.25), .clear, TLVTheme.bg.opacity(0.45)], startPoint: .top, endPoint: .bottom)
                .allowsHitTesting(false)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topControls
                    .padding(.top, 58)
                    .padding(.horizontal, 20)

                categoryChips
                    .padding(.top, 14)

                Spacer()

                selectedVenueCard
                    .padding(.horizontal, 20)
                    .padding(.bottom, 104)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var topControls: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(TLVTheme.fgMute)
                Text("Florentin, South TLV")
                    .font(.system(size: 13))
                    .foregroundColor(TLVTheme.fgMute)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(TLVTheme.surface.opacity(0.92))
            .background(.ultraThinMaterial)
            .overlay(Capsule().stroke(TLVTheme.lineStrong, lineWidth: 1))
            .clipShape(Capsule())

            Button(action: {}) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(TLVTheme.bg)
                    .frame(width: 44, height: 44)
                    .background(TLVTheme.amber)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(["All", "Bars", "Clubs", "Live music", "Late eats"], id: \.self) { category in
                    ChipButton(title: category, active: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var selectedVenueCard: some View {
        NavigationLink(value: AppRoute.eventDetail(selectedEvent.id)) {
            HStack(spacing: 12) {
                PlaceholderImage(height: 56, hue: selectedEvent.hue, cornerRadius: 10)
                    .frame(width: 56)

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        DisplayText(text: selectedEvent.venue.uppercased(), size: 18, tracking: 0.8)
                            .lineLimit(1)
                        if selectedEvent.live {
                            LiveBadge(small: true)
                        }
                    }
                    Text("\(selectedEvent.category) / Open until \(selectedEvent.endTime) / \(selectedEvent.waitTime)")
                        .font(.system(size: 11))
                        .foregroundColor(TLVTheme.fgMute)
                        .lineLimit(1)
                    Text(selectedEvent.friendsGoing)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(TLVTheme.amber)
                        .lineLimit(1)
                }

                Spacer()

                Text("Open")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(TLVTheme.bg)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(TLVTheme.amber)
                    .clipShape(Capsule())
            }
            .padding(14)
            .background(TLVTheme.surface.opacity(0.96))
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: TLVTheme.radiusLarge)
                    .stroke(TLVTheme.lineStrong, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TLVTheme.radiusLarge))
        }
        .buttonStyle(.plain)
    }
}

private struct MapPinItem: Identifiable {
    let id: String
    let title: String
    let eventID: String?
    let latitude: Double
    let longitude: Double
    let color: Color
    let isUser: Bool

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

private struct EventPin: View {
    let title: String
    let color: Color
    let selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: selected ? 12 : 10, weight: .black))
                    .tracking(0.3)
                    .foregroundColor(TLVTheme.bg)
                    .lineLimit(1)
                    .padding(.horizontal, selected ? 12 : 9)
                    .padding(.vertical, selected ? 6 : 4)
                    .background(color)
                    .overlay(
                        Capsule().stroke(selected ? TLVTheme.fg : .clear, lineWidth: 2)
                    )
                    .clipShape(Capsule())
                    .shadow(color: color.opacity(0.75), radius: selected ? 20 : 12)

                Triangle()
                    .fill(color)
                    .frame(width: 10, height: 6)
                    .rotationEffect(.degrees(180))
            }
        }
        .buttonStyle(.plain)
    }
}

private struct UserLocationDot: View {
    var body: some View {
        Circle()
            .fill(TLVTheme.blue)
            .frame(width: 16, height: 16)
            .overlay(Circle().stroke(TLVTheme.bg, lineWidth: 3))
            .shadow(color: TLVTheme.blue.opacity(0.7), radius: 12)
            .overlay(
                Circle()
                    .stroke(TLVTheme.blue.opacity(0.28), lineWidth: 8)
            )
    }
}
