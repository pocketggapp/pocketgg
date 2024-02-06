final class PhaseGroupSetService {
  static func getSetOutcome(score0: String?, score1: String?) -> PhaseGroupSet.Outcome {
    guard let score0, let score1 else { return .noWinner }
    
    if let score0Num = Int(score0), let score1Num = Int(score1) {
      if score0Num > score1Num {
        return .entrant0Won
      } else if score1Num > score0Num {
        return .entrant1Won
      } else {
        return .noWinner
      }
    } else if score0 == "W" || score0 == "✓" {
      return .entrant0Won
    } else if score1 == "W" || score1 == "✓" {
      return .entrant1Won
    } else {
      return .noWinner
    }
  }
}
