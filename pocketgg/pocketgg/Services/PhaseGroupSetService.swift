import StartggAPI

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
  
  /// Sort the sets by identifier, and if a grand finals reset set exists, increment its roundNum
  static func normalizeSets(sets: [PhaseGroupSet]?, bracketType: BracketType?) -> [PhaseGroupSet]? {
    guard let sets else { return nil }
    
    switch bracketType {
    case .singleElimination, .doubleElimination:
      // First sort the sets by the number of characters in their identifier
      // Then sort the the sets by their identifier's alphabetical order
      var sets = sets.sorted {
        if $0.identifier.count != $1.identifier.count {
          return $0.identifier.count < $1.identifier.count
        } else {
          return $0.identifier < $1.identifier
        }
      }
      
      // In the case of a grand finals reset, the 2nd grand finals may have the same roundNum as the 1st grand finals set
      // Therefore, if a set is detected with identical previous round IDs (meaning that the set is a grand finals reset), increment the roundNum
      for (i, set) in sets.enumerated() {
        guard set.prevRoundIDs.count == 2 else { continue }
        if set.prevRoundIDs[0] == set.prevRoundIDs[1] {
          sets[i].roundNum += 1
        }
      }
      
      return sets
    default: break
    }
    return nil
  }
  
  /// Generate all of the round labels for a bracket (eg. Winners Round 1)
  static func generateRoundLabels(sets: [PhaseGroupSet]?, bracketType: BracketType?) -> [PhaseGroupDetails.RoundLabel]? {
    guard let sets else { return nil }
    
    switch bracketType {
    case .singleElimination, .doubleElimination:
      var roundNums = Set<Int>()
      var roundLabels = [PhaseGroupDetails.RoundLabel]()
      
      for set in sets {
        if !roundNums.contains(set.roundNum) {
          roundLabels.append(.init(id: set.roundNum, text: set.fullRoundText ?? ""))
          roundNums.insert(set.roundNum)
        }
      }
      
      return roundLabels
    default: break
    }
    return nil
  }
}
