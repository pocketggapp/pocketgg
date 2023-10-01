import SwiftUI

@main
struct pocketggApp: App {
  let persistenceController = PersistenceController.shared
  @StateObject private var appRootManager = AppRootManager()

  var body: some Scene {
    WindowGroup {
      Group {
        switch appRootManager.currentRoot {
        case .login:
          LoginView()
        case .home:
          TabView {
            HomeView()
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
