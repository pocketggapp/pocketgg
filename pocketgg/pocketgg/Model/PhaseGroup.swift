import Foundation

/// A pool within a certain phase
///
/// Eg: R1 Pools can have many phase groups, whereas Top 8 only has 1
struct PhaseGroup: Identifiable, Hashable {
  let id: Int
  let name: String?
  let state: String?
}

struct PhaseGroupDetails {
  let bracketType: String?
  let progressionsOut: [Int]
  let standings: [Standing]
  let matches: [PhaseGroupSet]
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
  let entrants: [PhaseGroupSetEntrant]?
}

struct PhaseGroupSetEntrant: Hashable {
  let entrant: Entrant?
  let score: String?
}
