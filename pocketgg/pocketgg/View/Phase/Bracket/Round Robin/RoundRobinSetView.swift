import SwiftUI

struct RoundRobinSetView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let phaseGroupSet: PhaseGroupSet
  private let entrantID: Int?
  
  private var entrantWon: Bool? {
    switch phaseGroupSet.outcome {
    case .entrant0Won:
      return entrantID == phaseGroupSet.entrants?[safe: 0]?.entrant?.id
    case .entrant1Won:
      return entrantID == phaseGroupSet.entrants?[safe: 1]?.entrant?.id
    case .noWinner:
      return nil
    }
  }
  
  private var color: Color {
    if let entrantWon {
      return entrantWon ? Color.green : Color.red
    }
    return Color.gray
  }
  
  private var scoreText: String {
    let score0 = phaseGroupSet.entrants?[safe: 0]?.score ?? "_"
    let score1 = phaseGroupSet.entrants?[safe: 1]?.score ?? "_"
    
    if (phaseGroupSet.outcome == .entrant0Won && color == .green) || (phaseGroupSet.outcome == .entrant1Won && color == .red) {
      return score0 + " - " + score1
    } else if (phaseGroupSet.outcome == .entrant0Won && color == .red) || (phaseGroupSet.outcome == .entrant1Won && color == .green) {
      return score1 + " - " + score0
    } else {
      return "-"
    }
  }
  
  init(phaseGroupSet: PhaseGroupSet, entrantID: Int?) {
    self.phaseGroupSet = phaseGroupSet
    self.entrantID = entrantID
  }
  
  var body: some View {
    Text(scoreText)
      .foregroundColor(color)
      .font(.headline)
      .lineLimit(1)
      .padding()
      .frame(width: RoundRobinBracketView.setWidth * scale)
      .border(color, width: 2)
  }
}

#Preview {
  RoundRobinSetView(
    phaseGroupSet: MockStartggService.createPhaseGroupSet(),
    entrantID: 0
  )
}
