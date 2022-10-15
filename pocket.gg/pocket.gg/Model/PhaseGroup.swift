//
//  PhaseGroup.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-08-31.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

/// A pool within a certain phase
///
/// Eg: R1 Pools can have many phase groups, whereas Top 8 only has 1
struct PhaseGroup {
  // Info needed by PhaseGroupListVC
  // Query 3 - PhaseGroupsById
  let id: Int?
  let name: String?
  let state: String?
  
  // On-demand data for PhaseGroupVC
  // Query 4 - PhaseGroupStandingsById
  var bracketType: String?
  var progressionsOut: [Int]?
  var standings: [Standing]?
  var matches: [PhaseGroupSet]?
}
