import SwiftUI

@main
struct pocketggApp: App {
  let persistenceController = PersistenceController.shared
  @StateObject private var appRootManager = AppRootManager()
  
  private let oAuthService = OAuthService()

  var body: some Scene {
    WindowGroup {
      Group {
        switch appRootManager.currentRoot {
        case .startup:
          AppStartupView()
        case .login:
          LoginView()
        case .home:
          TabView {
            HomeView()
              .tabItem {
                Label("Tournaments", systemImage: "trophy.fill")
              }
            FollowingView()
              .tabItem {
                Label("Following", systemImage: "person.3.fill")
              }
            ProfileView()
              .tabItem {
                Label("Profile", systemImage: "person.fill")
              }
            SettingsView()
              .tabItem {
                Label("Settings", systemImage: "gear")
              }
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
