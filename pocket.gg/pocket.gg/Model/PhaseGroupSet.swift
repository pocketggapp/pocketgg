//
//  PhaseGroupSet.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-09-10.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

struct PhaseGroupSet {
  let id: Int?
  let state: String?
  var roundNum: Int // Not defined as constant because in the case of a grand finals reset, this property can be incremented to resolve any issues
  let identifier: String
  let fullRoundText: String?
  let prevRoundIDs: [Int]?
  var entrants: [(entrant: Entrant?, score: String?)]?
}
