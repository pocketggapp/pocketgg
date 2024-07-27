import Foundation
import StartggAPI

/// A pool within a certain phase
///
/// Eg: R1 Pools can have many phase groups, whereas Top 8 only has 1. Used by **PhaseGroupListView**
struct PhaseGroup: Hashable {
  let id: Int
  let name: String?
  let state: ActivityState
}

/// Complete Phase Group data
///
/// Used by **PhaseGroupView**
struct PhaseGroupDetails {
  let bracketType: BracketType?
  let progressionsOut: Set<Int>
  let standings: [Standing]
  // Not constant because if 90 sets are returned, this property can appended to with additional sets
  var matches: [PhaseGroupSet]
  // Initialized as empty, then populated in PhaseGroupViewModel
  var roundLabels = [RoundLabel]()
  var phaseGroupSetRounds = [Int: Int]()
  
  struct RoundLabel {
    var id: Int // roundNum
    let text: String
  }
}

struct Standing: Hashable {
  let id = UUID()
  let entrant: Entrant?
  let placement: Int?
}
