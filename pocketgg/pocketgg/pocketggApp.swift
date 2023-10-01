import SwiftUI

@main
struct pocketggApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      LoginView()
//      TabView {
//        HomeView()
//          .tabItem {
//            Label("Tournaments", systemImage: "pencil.circle.fill")
//          }
//        SettingsView()
//          .tabItem {
//            Label("Settings", systemImage: "gear")
//          }
//      }
    }
  }
}
