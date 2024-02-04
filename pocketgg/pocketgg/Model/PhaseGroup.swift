import Foundation

/// A pool within a certain phase
///
/// Eg: R1 Pools can have many phase groups, whereas Top 8 only has 1
struct PhaseGroup: Identifiable, Hashable {
  let id: Int
  let name: String?
  let state: String?
  
  // On-demand data for PhaseGroupVC
  // Query 4 - PhaseGroupStandingsById
  var bracketType: String?
  var progressionsOut: [Int]?
  var standings: [Standing]?
  var matches: [PhaseGroupSet]?
}

struct Standing: Identifiable, Hashable {
  let id = UUID()
  let entrant: Entrant?
  let placement: Int?
}

struct PhaseGroupSet: Hashable {
  let id: Int
  let state: String?
  var roundNum: Int // Not defined as constant because in the case of a grand finals reset, this property can be incremented to resolve any issues
  let identifier: String
  let fullRoundText: String?
  let prevRoundIDs: [Int]?
//  var entrants: [(entrant: Entrant?, score: String?)]?
}
