import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case route
    case map
    case friends
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .route: return "Route"
        case .map: return "Map"
        case .friends: return "Friends"
        case .profile: return "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .route: return "figure.walk.motion"
        case .map: return "map.fill"
        case .friends: return "person.2.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

enum AppRoute: Hashable {
    case eventDetail(String)
    case search
    case notifications
}

enum AppSheet: String, Identifiable {
    case filters

    var id: String { rawValue }
}
