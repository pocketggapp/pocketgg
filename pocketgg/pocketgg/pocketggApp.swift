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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
