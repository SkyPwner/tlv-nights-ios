import SwiftUI

struct MainTabShellView: View {
    @State private var selectedTab: AppTab = .home
    @State private var homePath: [AppRoute] = []
    @State private var routePath: [AppRoute] = []
    @State private var mapPath: [AppRoute] = []
    @State private var friendsPath: [AppRoute] = []
    @State private var profilePath: [AppRoute] = []
    @State private var activeSheet: AppSheet?

    var body: some View {
        ZStack(alignment: .bottom) {
            TLVBackground()
                .ignoresSafeArea()

            ZStack {
                ForEach(AppTab.allCases) { tab in
                    tabStack(for: tab)
                        .opacity(selectedTab == tab ? 1 : 0)
                        .allowsHitTesting(selectedTab == tab)
                        .accessibilityHidden(selectedTab != tab)
                }
            }

            TLVTabBar(selection: $selectedTab)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .filters:
                FilterSheetView()
                    .presentationDetents([.fraction(0.88), .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    @ViewBuilder
    private func tabStack(for tab: AppTab) -> some View {
        NavigationStack(path: binding(for: tab)) {
            tabRoot(for: tab)
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func binding(for tab: AppTab) -> Binding<[AppRoute]> {
        switch tab {
        case .home:
            return $homePath
        case .route:
            return $routePath
        case .map:
            return $mapPath
        case .friends:
            return $friendsPath
        case .profile:
            return $profilePath
        }
    }

    @ViewBuilder
    private func tabRoot(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeView(
                onOpenFilters: { activeSheet = .filters },
                onSelectTab: { selectedTab = $0 }
            )
        case .route:
            RouteView()
        case .map:
            TLVMapScreen()
        case .friends:
            FriendsView()
        case .profile:
            ProfileView()
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .eventDetail(let eventID):
            EventDetailView(event: MockTLVData.event(id: eventID))
        case .search:
            SearchView()
        case .notifications:
            NotificationsView()
        }
    }
}
