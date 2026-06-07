import CoreLocation
import Foundation

struct TLVEvent: Identifiable, Hashable {
    let id: String
    let title: String
    let venue: String
    let address: String
    let category: String
    let genre: String
    let vibe: String
    let startTime: String
    let endTime: String
    let entry: String
    let distance: String
    let waitTime: String
    let friendsGoing: String
    let summary: String
    let live: Bool
    let hue: Double
    let latitude: Double
    let longitude: Double
    let tags: [String]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct TLVFriend: Identifiable, Hashable {
    let id: String
    let initials: String
    let name: String
    let status: String
    let destination: String?
    let hue: Double
    let isLive: Bool
    let isMuted: Bool
}

struct EveningStop: Identifiable, Hashable {
    let id: String
    let eventID: String
    let time: String
    let name: String
    let kind: String
    let meta: String
    let state: StopState
}

enum StopState: String, Hashable {
    case done
    case now
    case next
}

struct InboxNotification: Identifiable, Hashable {
    let id: String
    let kind: NotificationKind
    let title: String
    let body: String
    let time: String
    let unread: Bool
    let friendInitials: String?
    let friendHue: Double?
}

enum NotificationKind: String, Hashable {
    case route
    case friend
    case venue
    case event
    case confirm
}

struct SearchResult: Identifiable, Hashable {
    let id: String
    let type: SearchResultType
    let title: String
    let subtitle: String
    let goingCount: Int?
    let eventID: String?
}

enum SearchResultType: String, CaseIterable, Hashable {
    case all = "All"
    case events = "Events"
    case venues = "Venues"
    case djs = "DJs"
    case friends = "Friends"

    var tileLabel: String {
        switch self {
        case .all: return "A"
        case .events: return "E"
        case .venues: return "V"
        case .djs: return "D"
        case .friends: return "F"
        }
    }
}

struct OnboardingSlide: Identifiable, Hashable {
    let id: Int
    let title: String
    let body: String
}
