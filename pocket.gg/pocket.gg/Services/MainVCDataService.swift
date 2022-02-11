//
//  MainVCDataService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-05-08.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class MainVCDataService {
    
    // Enabled Sections
    
    static func getEnabledSections() -> [Int] {
        return UserDefaults.standard.array(forKey: k.UserDefaults.mainVCSections) as? [Int] ?? []
    }
    
    static func updateEnabledSections(_ enabledSections: [Int]) {
        UserDefaults.standard.set(enabledSections, forKey: k.UserDefaults.mainVCSections)
    }
    
    // Pinned Tournaments
    
    static func getPinnedTournamentIDs() -> [Int] {
        return UserDefaults.standard.array(forKey: k.UserDefaults.pinnedTournamentIDs) as? [Int] ?? []
    }
    
    static func updatePinnedTournamentIDs(_ pinnedTournaments: [Tournament]? = nil, _ newPinnedTournamentIDs: [Int]? = nil) {
        let pinnedTournamentIDs: [Int]
        if let pinnedTournaments = pinnedTournaments {
            pinnedTournamentIDs = pinnedTournaments.compactMap { $0.id }
        } else if let newPinnedTournamentIDs = newPinnedTournamentIDs {
            pinnedTournamentIDs = newPinnedTournamentIDs
        } else {
            return
        }
        UserDefaults.standard.set(pinnedTournamentIDs, forKey: k.UserDefaults.pinnedTournamentIDs)
    }
    
    // Enabled Games
    
    static func getEnabledGames() -> [VideoGame] {
        var videoGames = [VideoGame]()
        if let data = UserDefaults.standard.data(forKey: k.UserDefaults.preferredVideoGames) {
            do {
                videoGames = try PropertyListDecoder().decode([VideoGame].self, from: data)
            } catch {
                print(error.localizedDescription)
                return []
            }
        }
        return videoGames
    }
    
    static func updateEnabledGames(_ games: [VideoGame]) {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(games), forKey: k.UserDefaults.preferredVideoGames)
        } catch {
            print(error.localizedDescription)
        }
    }
}
