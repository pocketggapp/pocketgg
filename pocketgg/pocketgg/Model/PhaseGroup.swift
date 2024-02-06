import Foundation

/// A pool within a certain phase
///
/// Eg: R1 Pools can have many phase groups, whereas Top 8 only has 1. Used by **PhaseGroupListView**
struct PhaseGroup: Identifiable, Hashable {
  let id: Int
  let name: String?
  let state: String?
}

/// Complete Phase Group data
///
/// Used by **PhaseGroupView**
struct PhaseGroupDetails {
  let bracketType: String?
  let progressionsOut: Set<Int>
  let standings: [Standing]
  let matches: [PhaseGroupSet]
}

struct Standing: Identifiable, Hashable {
  let id = UUID()
  let entrant: Entrant?
  let placement: Int?
}

struct PhaseGroupSet: Identifiable, Hashable {
  let id: Int
  let state: String
  var roundNum: Int // Not defined as constant because in the case of a grand finals reset, this property can be incremented to resolve any issues
  let identifier: String?
  let outcome: Outcome
  let fullRoundText: String?
  let prevRoundIDs: [Int]?
  let entrants: [PhaseGroupSetEntrant]?
  
  enum Outcome {
    case entrant0Won
    case entrant1Won
    case noWinner
  }
}

struct PhaseGroupSetEntrant: Hashable {
  let entrant: Entrant?
  let score: String?
}
