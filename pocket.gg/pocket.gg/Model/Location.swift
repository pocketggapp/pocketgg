//
//  Location.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-08-31.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

/// Where the tournament is located
///
/// The address for each tournament pre-fetched as part of the TournamentsByVideogames query, and the rest is fetched as a part of the TournamentDetailsById query
struct Location {
  let address: String?
  var venueName: String?
  var longitude: Double?
  var latitude: Double?
}
