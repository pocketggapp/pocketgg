import SwiftUI

struct EliminationRoundLabelView: View {
  private let roundLabel: PhaseGroupDetails.RoundLabel
  
  init(roundLabel: PhaseGroupDetails.RoundLabel) {
    self.roundLabel = roundLabel
  }
  
  var body: some View {
    Text(roundLabel.text)
      .font(.headline)
      .padding()
  }
}

#Preview {
  EliminationRoundLabelView(
    roundLabel: MockStartggService.createRoundLabel()
  )
}
