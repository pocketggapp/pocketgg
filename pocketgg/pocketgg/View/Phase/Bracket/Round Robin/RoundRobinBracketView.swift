import SwiftUI

struct RoundRobinBracketView: View {
  @Binding private var selectedSet: PhaseGroupSet?
  
  private let phaseGroupSets: [PhaseGroupSet]
  private let entrants: [Entrant]
  
  static let setWidth: CGFloat = 120
  
  init(
    selectedSet: Binding<PhaseGroupSet?>,
    phaseGroupSets: [PhaseGroupSet],
    entrants: [Entrant]
  ) {
    self._selectedSet = selectedSet
    self.phaseGroupSets = phaseGroupSets
    self.entrants = entrants
  }
  
  var body: some View {
    ScrollViewWrapper {
      Grid(horizontalSpacing: 5, verticalSpacing: 5) {
        // Top Row of Entrant Names
        GridRow {
          Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
          ForEach(entrants, id: \.id) {
            RoundRobinEntrantView(entrant: $0)
          }
          Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
        }
        
        ForEach(entrants, id: \.id) { entrant0 in
          GridRow {
            RoundRobinEntrantView(entrant: entrant0)
            
            ForEach(entrants, id: \.id) { entrant1 in
              if let set = roundRobinSet(for: entrant0, and: entrant1) {
                RoundRobinSetView(phaseGroupSet: set, entrantID: entrant0.id)
                  .onTapGesture {
                    selectedSet = set
                  }
              } else {
                Color(uiColor: .secondarySystemBackground)
                  .gridCellUnsizedAxes([.horizontal, .vertical])
              }
            }
            
            RoundRobinScoreView(score: getOverallScoreText(for: entrant0))
          }
        }
      }
    }
  }
  
  private func roundRobinSet(for entrant0: Entrant, and entrant1: Entrant) -> PhaseGroupSet? {
    guard entrant0.id != entrant1.id else { return nil }
    
    return phaseGroupSets.first {
      $0.entrants?.compactMap { info -> Bool? in
        guard let id = info.entrant?.id else { return nil }
        if id == entrant0.id {
          return true
        } else if id == entrant1.id {
          return true
        }
        return nil
      }.count == 2
    }
  }
  
  private func getOverallScoreText(for entrant: Entrant) -> (String, String) {
    var setsWon = 0
    var setsLost = 0
    var gamesWon = 0
    var gamesLost = 0
    
    for set in phaseGroupSets {
      guard let id0 = set.entrants?[safe: 0]?.entrant?.id else { return ("-", "-") }
      guard let id1 = set.entrants?[safe: 1]?.entrant?.id else { return ("-", "-") }
      
      guard let score0 = set.entrants?[safe: 0]?.score else { continue }
      guard let score1 = set.entrants?[safe: 1]?.score else { continue }
      
      if entrant.id == id0 || entrant.id == id1 {
        if let score0Num = Int(score0), let score1Num = Int(score1) {
          if entrant.id == id0 {
            setsWon += score0Num > score1Num ? 1 : 0
            setsLost += score0Num < score1Num ? 1 : 0
            gamesWon += score0Num
            gamesLost += score1Num
          } else if entrant.id == id1 {
            setsWon += score0Num < score1Num ? 1 : 0
            setsLost += score0Num > score1Num ? 1 : 0
            gamesWon += score1Num
            gamesLost += score0Num
          }
        } else if score0 == "W" || score1 == "W" {
          if entrant.id == id0 {
            setsWon += score0 == "W" ? 1 : 0
            setsLost += score1 == "W" ? 1 : 0
          } else if entrant.id == id1 {
            setsWon += score1 == "W" ? 1 : 0
            setsLost += score0 == "W" ? 1 : 0
          }
        } else if score0 == "✓" || score1 == "✓" {
          if entrant.id == id0 {
            setsWon += score0 == "✓" ? 1 : 0
            setsLost += score1 == "✓" ? 1 : 0
          } else if entrant.id == id1 {
            setsWon += score1 == "✓" ? 1 : 0
            setsLost += score0 == "✓" ? 1 : 0
          }
        }
      }
    }
    
    return ("\(setsWon) - \(setsLost)", "\(gamesWon) - \(gamesLost)")
  }
}

#Preview {
  return RoundRobinBracketView(
    selectedSet: .constant(nil),
    phaseGroupSets: [MockStartggService.createPhaseGroupSet()],
    entrants: [
      MockStartggService.createEntrant(id: 0),
      MockStartggService.createEntrant(id: 1)
    ]
  )
}
