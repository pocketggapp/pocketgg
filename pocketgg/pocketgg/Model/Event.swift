//
//  Event.swift
//  pocketgg
//
//  Created by Gabriel Siu on 2024-01-07.
//

import Foundation

struct Event: Identifiable {
  let id: Int?
  let name: String?
  let state: String?
  let winner: Entrant?
  
  // Preloaded data for EventVC
  // Query 1 - TournamentDetailsById
  let startDate: String?
  let eventType: Int?
  let videogameName: String?
  let videogameImage: (url: String?, ratio: Double?)?
}
