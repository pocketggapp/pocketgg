//
//  Tournament.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-02.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

/// A tournament that is registered on smash.gg
struct Tournament {
    
    // Info needed by MainVC
    // Query 0 - TournamentsByVideogames
    let id: Int?
    let name: String?
    let date: String?
    let logoUrl: String?
    let isOnline: Bool?
    
    // Preloaded data for TournamentVC
    // Query 0 - TournamentsByVideogames
    var location: Location?
    let headerImage: (url: String?, ratio: Double?)?
    
    // On-demand data for TournamentVC
    // Query 1 - TournamentDetailsById
    var events: [Event]?
    var streams: [Stream]?
    var registration: (isOpen: Bool?, closeDate: String?)?
    var contact: (info: String?, type: String?)?
    var slug: String?
    var ownerID: Int?
    var ownerName: String?
    var ownerPrefix: String?
}

/// Deprecated as of v1.2
struct SavedTournament: Codable {
    let id: Int?
    let name: String?
    let date: String?
    let logoUrl: String?
    let isOnline: Bool?
    
    let address: String?
    
    let headerImageURL: String?
    let headerImageRatio: Double?
}
