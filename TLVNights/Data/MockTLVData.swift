import Foundation

enum MockTLVData {
    static let onboardingSlides: [OnboardingSlide] = [
        OnboardingSlide(
            id: 0,
            title: "FIND TONIGHT'S\nBEST NIGHTS OUT",
            body: "See what's on across 200+ bars, clubs and underground venues across Tel Aviv."
        ),
        OnboardingSlide(
            id: 1,
            title: "BUILD YOUR\nEVENING ROUTE",
            body: "Stack 2-4 stops, get walking time, and let the app re-route around weather, queues and friends."
        ),
        OnboardingSlide(
            id: 2,
            title: "BRING YOUR\nFRIENDS ALONG",
            body: "See who's out, merge plans on the fly, and find each other across venues - no group-chat chaos."
        )
    ]

    static let events: [TLVEvent] = [
        TLVEvent(
            id: "underground-rap",
            title: "UNDERGROUND RAP NIGHT",
            venue: "Kuli Alma",
            address: "Mikveh Yisrael 10",
            category: "Event",
            genre: "Hip-hop / Experimental",
            vibe: "Intimate / Basement",
            startTime: "22:00",
            endTime: "04:00",
            entry: "NIS 60",
            distance: "2.1 km",
            waitTime: "~25 min queue",
            friendsGoing: "Noa, Ron, Itai +5",
            summary: "Six local MCs trading bars over dubby, sub-heavy beats. Late-night set from DJ Noam Helfer, analog-only. Expect a queue past midnight - we'll tell you when it clears.",
            live: true,
            hue: 20,
            latitude: 32.06258,
            longitude: 34.77377,
            tags: ["Live", "Rap", "Underground"]
        ),
        TLVEvent(
            id: "melodic-techno",
            title: "B-SIDE: MELODIC TECHNO",
            venue: "The Block",
            address: "Salame 157",
            category: "Club",
            genre: "Techno",
            vibe: "Dance floor",
            startTime: "23:30",
            endTime: "06:00",
            entry: "NIS 90",
            distance: "3.4 km",
            waitTime: "Heavy after 01:00",
            friendsGoing: "Itai +3",
            summary: "A late set of melodic techno and warehouse-room pressure. The best arrival window is before midnight.",
            live: false,
            hue: 260,
            latitude: 32.05566,
            longitude: 34.77664,
            tags: ["Techno", "Club"]
        ),
        TLVEvent(
            id: "jazz-dizengoff",
            title: "JAZZ ON DIZENGOFF",
            venue: "Beit HaAmudim",
            address: "Rambam 14",
            category: "Live music",
            genre: "Jazz",
            vibe: "Sit-down / Warm",
            startTime: "21:00",
            endTime: "00:30",
            entry: "NIS 75",
            distance: "1.7 km",
            waitTime: "Seats still open",
            friendsGoing: "Maya +1",
            summary: "Small-room jazz with a late second set, close enough to become a calm stop before clubs open.",
            live: false,
            hue: 30,
            latitude: 32.06927,
            longitude: 34.77194,
            tags: ["Jazz", "Live"]
        ),
        TLVEvent(
            id: "queer-disco",
            title: "QUEER DISCO",
            venue: "Shpagat",
            address: "Nahalat Binyamin 43",
            category: "Bar",
            genre: "Disco",
            vibe: "Queer / Friendly",
            startTime: "00:00",
            endTime: "04:00",
            entry: "Free",
            distance: "900 m",
            waitTime: "No cover",
            friendsGoing: "Shira +4",
            summary: "A friendly late stop with disco edits, drag-hosted pop moments, and room to actually talk.",
            live: true,
            hue: 340,
            latitude: 32.06413,
            longitude: 34.77134,
            tags: ["Live", "Disco", "Queer"]
        ),
        TLVEvent(
            id: "kitchen-sessions",
            title: "KITCHEN SESSIONS",
            venue: "Port Said",
            address: "Har Sinai 5",
            category: "Bar",
            genre: "Eclectic",
            vibe: "Late eats / Records",
            startTime: "22:00",
            endTime: "03:00",
            entry: "Free",
            distance: "1.2 km",
            waitTime: "~20 min wait",
            friendsGoing: "3 friends here now",
            summary: "Records, plates, and a late kitchen. Good fourth-stop energy when the dance floor starts to thin.",
            live: true,
            hue: 60,
            latitude: 32.06488,
            longitude: 34.77044,
            tags: ["Live", "Late eats", "Bar"]
        ),
        TLVEvent(
            id: "miznon",
            title: "DINNER BEFORE DOORS",
            venue: "Miznon",
            address: "Ibn Gabirol 23",
            category: "Late eats",
            genre: "Dinner",
            vibe: "Fast / Street food",
            startTime: "20:00",
            endTime: "23:00",
            entry: "NIS 55 avg",
            distance: "600 m",
            waitTime: "Tables free now",
            friendsGoing: "Noa nearby",
            summary: "A quick dinner stop that still gets you to Kuli Alma before the door rush.",
            live: false,
            hue: 40,
            latitude: 32.07322,
            longitude: 34.78112,
            tags: ["Food", "Route"]
        )
    ]

    static let eveningStops: [EveningStop] = [
        EveningStop(id: "stop-miznon", eventID: "miznon", time: "20:00", name: "Miznon", kind: "Dinner / Pita bar", meta: "Checked in 18:58", state: .done),
        EveningStop(id: "stop-artclub", eventID: "underground-rap", time: "22:00", name: "ArtClub", kind: "Concert / Rap night", meta: "Doors open / 5 min walk from here", state: .now),
        EveningStop(id: "stop-shpagat", eventID: "queer-disco", time: "01:00", name: "Shpagat", kind: "Late drinks", meta: "Quiet until midnight / No cover", state: .next)
    ]

    static let friends: [TLVFriend] = [
        TLVFriend(id: "noa", initials: "NA", name: "Noa Avidan", status: "At Miznon / 2 km", destination: "-> Kuli Alma at 22:15", hue: 320, isLive: false, isMuted: false),
        TLVFriend(id: "ron", initials: "RO", name: "Ron Hadar", status: "Home / getting ready", destination: "-> ArtClub later", hue: 140, isLive: false, isMuted: false),
        TLVFriend(id: "itai", initials: "IT", name: "Itai Barak", status: "At The Block / dancing", destination: "Live now", hue: 40, isLive: true, isMuted: false),
        TLVFriend(id: "shira", initials: "SH", name: "Shira Cohen", status: "At Port Said / 400m", destination: "With Nadav", hue: 260, isLive: false, isMuted: false),
        TLVFriend(id: "eitan", initials: "ET", name: "Eitan Levy", status: "Last seen / 2h ago", destination: nil, hue: 60, isLive: false, isMuted: true),
        TLVFriend(id: "maya", initials: "MK", name: "Maya Klein", status: "Last seen / yesterday", destination: nil, hue: 180, isLive: false, isMuted: true),
        TLVFriend(id: "yoav", initials: "YO", name: "Yoav Peretz", status: "Last seen / 3 days ago", destination: nil, hue: 220, isLive: false, isMuted: true),
        TLVFriend(id: "dana", initials: "DA", name: "Dana Eshed", status: "Last seen / last week", destination: nil, hue: 0, isLive: false, isMuted: true)
    ]

    static let notifications: [InboxNotification] = [
        InboxNotification(id: "route-rain", kind: .route, title: "Route updated / rain incoming", body: "We swapped your rooftop pick at 21:30 to ArtClub. Tap to review.", time: "now", unread: true, friendInitials: nil, friendHue: nil),
        InboxNotification(id: "noa-checkin", kind: .friend, title: "Noa just checked in at Miznon", body: "She's on your evening route - arriving 12 min before you.", time: "4 min", unread: true, friendInitials: "NA", friendHue: 320),
        InboxNotification(id: "kuli-live", kind: .venue, title: "Kuli Alma is live now", body: "Doors just opened. Queue forming in ~25 min based on last Fridays.", time: "18 min", unread: true, friendInitials: nil, friendHue: nil),
        InboxNotification(id: "new-events", kind: .event, title: "5 new events near Florentin", body: "Including 2 in genres you like. Tap to see.", time: "17:02", unread: false, friendInitials: nil, friendHue: nil),
        InboxNotification(id: "itai-route", kind: .friend, title: "Itai shared a route with you", body: "B-Side -> Port Said -> late shakshuka. Opens in 20:30.", time: "15:41", unread: false, friendInitials: "IT", friendHue: 40),
        InboxNotification(id: "confirmed", kind: .confirm, title: "Evening plan confirmed", body: "Miznon (20:00) / ArtClub (22:00) / Shpagat (01:00)", time: "14:20", unread: false, friendInitials: nil, friendHue: nil),
        InboxNotification(id: "queue-clear", kind: .venue, title: "Shpagat queue cleared", body: "Good window to arrive before your 01:00 stop.", time: "12:08", unread: false, friendInitials: nil, friendHue: nil)
    ]

    static let searchResults: [SearchResult] = [
        SearchResult(id: "search-techno", type: .events, title: "TECHNO TUESDAY", subtitle: "Breakfast Club / Tonight 23:00", goingCount: 24, eventID: "melodic-techno"),
        SearchResult(id: "search-block", type: .venues, title: "THE BLOCK", subtitle: "Salame 157 / Open Fri-Sat", goingCount: nil, eventID: "melodic-techno"),
        SearchResult(id: "search-guy", type: .djs, title: "GUY GERBER", subtitle: "12 upcoming sets", goingCount: nil, eventID: nil),
        SearchResult(id: "search-rave", type: .events, title: "RAVE BUNKER", subtitle: "Kuli Alma / Sat 01:00", goingCount: 45, eventID: "underground-rap"),
        SearchResult(id: "search-alpha", type: .venues, title: "ALPHABET", subtitle: "Lilienblum / Open tonight", goingCount: nil, eventID: nil)
    ]

    static func event(id: String) -> TLVEvent {
        events.first(where: { $0.id == id }) ?? events[0]
    }
}
