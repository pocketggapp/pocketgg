//
//  PinnedTournamentsService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-06-13.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import Foundation

final class PinnedTournamentsService {
    private static var pinnedTournaments = [SavedTournament]()
    static var numPinnedTournaments: Int { pinnedTournaments.count }
    
    static func initPinnedTournaments() {
        if let data = UserDefaults.standard.data(forKey: k.UserDefaults.pinnedTournaments) {
            do {
                pinnedTournaments = try PropertyListDecoder().decode([SavedTournament].self, from: data)
            } catch {
                print(error.localizedDescription)
                pinnedTournaments = []
            }
        }
    }
    
    static func togglePinnedTournament(_ tournament: Tournament) -> Bool {
        if let index = pinnedTournaments.firstIndex(where: {
            guard let tournamentID = tournament.id, let id = $0.id else { return false }
            return tournamentID == id
        }) {
            pinnedTournaments.remove(at: index)
        } else {
            // Don't allow more than 30 pinned tournaments
            guard numPinnedTournaments < 30 else { return false }
            pinnedTournaments.append(SavedTournament(id: tournament.id,
                                                          name: tournament.name,
                                                          date: tournament.date,
                                                          logoUrl: tournament.logoUrl,
                                                          isOnline: tournament.isOnline,
                                                          address: tournament.location?.address,
                                                          headerImageURL: tournament.headerImage?.url,
                                                          headerImageRatio: tournament.headerImage?.ratio))
        }
        
        savePinnedTournaments()
        return true
    }
    
    static func tournamentIsPinned(_ tournamentID: Int) -> Bool {
        return pinnedTournaments.contains(where: {
            guard let id = $0.id else { return false }
            return tournamentID == id
        })
    }
    
    static func rearrangePinnedTournaments(sourceIndex: Int, destinationIndex: Int) {
        let movedTournament = pinnedTournaments.remove(at: sourceIndex)
        pinnedTournaments.insert(movedTournament, at: destinationIndex)
        savePinnedTournaments()
    }
    
    static func updatePinnedTournaments(_ tournaments: [Tournament]) {
        pinnedTournaments = tournaments.map {
            SavedTournament(id: $0.id,
                                 name: $0.name,
                                 date: $0.date,
                                 logoUrl: $0.logoUrl,
                                 isOnline: $0.isOnline,
                                 address: $0.location?.address,
                                 headerImageURL: $0.headerImage?.url,
                                 headerImageRatio: $0.headerImage?.ratio)
        }
        savePinnedTournaments()
    }
    
    static func pinnedTournament(at index: Int) -> Tournament? {
        guard let tournament = pinnedTournaments[safe: index] else { return nil }
        return Tournament(id: tournament.id,
                          name: tournament.name,
                          date: tournament.date,
                          logoUrl: tournament.logoUrl,
                          isOnline: tournament.isOnline,
                          location: Location(address: tournament.address),
                          headerImage: (url: tournament.headerImageURL, ratio: tournament.headerImageRatio))
    }
    
    static func getPinnedTournaments() -> [Tournament] {
        return pinnedTournaments.map {
            Tournament(id: $0.id,
                       name: $0.name,
                       date: $0.date,
                       logoUrl: $0.logoUrl,
                       isOnline: $0.isOnline,
                       location: Location(address: $0.address),
                       headerImage: (url: $0.headerImageURL, ratio: $0.headerImageRatio))
        }
    }
    
    private static func savePinnedTournaments() {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(pinnedTournaments), forKey: k.UserDefaults.pinnedTournaments)
        } catch {
            print(error.localizedDescription)
        }
    }
}
