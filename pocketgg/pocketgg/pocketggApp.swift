import SwiftUI

@main
struct pocketggApp: App {
  @StateObject private var appRootManager = AppRootManager()
  @State private var selectedHomeTabIndex = 0

  var body: some Scene {
    WindowGroup {
      Group {
        switch appRootManager.currentRoot {
        case .startup:
          AppStartupView()
        case .login:
          LoginView()
        case .home:
          TabView(selection: $selectedHomeTabIndex) {
            HomeView()
              .tabItem {
                Label("Tournaments", systemImage: "trophy.fill")
              }
              .tag(0)
            FollowingView()
              .tabItem {
                Label("Following", systemImage: "person.3.fill")
              }
              .tag(1)
            TournamentSearchView()
              .tabItem {
                Label("Search", systemImage: "magnifyingglass")
              }
              .tag(2)
            ProfileView()
              .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
              }
              .tag(3)
            SettingsView()
              .tabItem {
                Label("Settings", systemImage: "gear")
              }
              .tag(4)
          }
          .onOpenURL { _ in
            selectedHomeTabIndex = 0
          }
        }
      }
      .environmentObject(appRootManager)
    }
  }
}

extension UIApplication {
  var rootViewController: UIViewController? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive }
      .first?.keyWindow?.rootViewController
  }
}
