import SwiftUI

@main
struct TLVNightsApp: App {
    @StateObject private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .preferredColorScheme(.dark)
        }
    }
}

@MainActor
final class AppSession: ObservableObject {
    @Published var hasEnteredApp = false
    @Published var isVerified = false

    func finishVerification() {
        isVerified = true
    }

    func enterApp() {
        hasEnteredApp = true
    }

    func logOut() {
        hasEnteredApp = false
        isVerified = false
    }
}

private struct RootView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        Group {
            if session.hasEnteredApp {
                MainTabShellView()
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                AuthFlowView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.24), value: session.hasEnteredApp)
    }
}
