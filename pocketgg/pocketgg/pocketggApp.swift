//
//  pocketggApp.swift
//  pocketgg
//
//  Created by Gabriel Siu on 2023-07-11.
//

import SwiftUI

@main
struct pocketggApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
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
}
