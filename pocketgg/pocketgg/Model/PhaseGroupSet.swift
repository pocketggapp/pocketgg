import StartggAPI

struct PhaseGroupSet: Identifiable, Hashable {
  let id: Int
  let state: ActivityState
  var roundNum: Int // Not defined as constant because in the case of a grand finals reset, this property can be incremented to resolve any issues
  let identifier: String
  let outcome: Outcome
  let fullRoundText: String?
  let prevRoundIDs: [Int]
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

/// Complete Phase Group Set data
///
/// Used by **PhaseGroupSetView**
struct PhaseGroupSetDetails {
  let phaseGroupSet: PhaseGroupSet
  let games: [PhaseGroupSetGame]
  let stationNum: Int?
  let stream: Stream?
}

struct PhaseGroupSetGame {
  let id: Int
  let gameNum: Int?
  let winnerID: Int?
  let stageName: String?
}
