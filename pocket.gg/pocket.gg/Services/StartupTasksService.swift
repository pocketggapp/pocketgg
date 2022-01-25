//
//  StartupTasksService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-01-22.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import Foundation

final class StartupTasksService {
    
    /// Refactor app structure for v1.2
    /// - A central Int array is used to determine which sections are enabled on MainVC
    ///     - Video Games are represented in the array by their IDs
    /// - The showPinnedTournaments, featuredTournaments, upcomingTournaments flags are removed, and replaced by entries in the aforementioned array as follows:
    ///     - showPinnedTournaments: -1
    ///     - featuredTournaments: -2
    ///     - upcomingTournaments: -3
    /// - Saving pinned tournaments as SavedTournament instances is replaced by storing just the IDs of the pinned tournaments
    static func appVersionMigration1() {
        if !UserDefaults.standard.bool(forKey: k.UserDefaults.appVersionMigration1) {
            // Initialize enabledSections array for MainVC
            let enabledSections = [-1, -2, -3] + MainVCDataService.getEnabledGames().map { $0.id }
            UserDefaults.standard.set(enabledSections, forKey: k.UserDefaults.mainVCSections)
            
            // Migrate pinned tournaments
            var oldPinnedTournaments = [SavedTournament]()
            if let data = UserDefaults.standard.data(forKey: k.UserDefaults.pinnedTournaments) {
                do {
                    oldPinnedTournaments = try PropertyListDecoder().decode([SavedTournament].self, from: data)
                } catch {
                    oldPinnedTournaments = []
                }
            }
            let pinnedTournamentIDs = oldPinnedTournaments.compactMap { $0.id }
            UserDefaults.standard.set(pinnedTournamentIDs, forKey: k.UserDefaults.pinnedTournamentIDs)
            UserDefaults.standard.removeObject(forKey: k.UserDefaults.pinnedTournaments)
            
            // Remove deprecated UserDefaults objects
            UserDefaults.standard.removeObject(forKey: k.UserDefaults.showPinnedTournaments)
            UserDefaults.standard.removeObject(forKey: k.UserDefaults.featuredTournaments)
            UserDefaults.standard.removeObject(forKey: k.UserDefaults.upcomingTournaments)
            
            UserDefaults.standard.set(true, forKey: k.UserDefaults.appVersionMigration1)
        }
    }
}
