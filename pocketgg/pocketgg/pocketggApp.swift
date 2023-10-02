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
        case .login:
          LoginView(viewModel: LoginViewModel(oAuthService: oAuthService))
        case .home:
          TabView {
            HomeView(viewModel: HomeViewModel(oAuthService: oAuthService))
              .tabItem {
                Label("Tournaments", systemImage: "pencil.circle.fill")
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
