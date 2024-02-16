import SwiftUI

struct PhaseGroupSetGameRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let game: PhaseGroupSetGame
  private let setEntrants: [Entrant]
  
  init(
    game: PhaseGroupSetGame,
    setEntrants: [Entrant]
  ) {
    self.game = game
    self.setEntrants = setEntrants
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Game \(game.gameNum ?? 0): \(game.stageName ?? "")")
      
      winnerTextView()
        .font(.caption)
    }
    .frame(height: 44 * scale)
  }
  
  @ViewBuilder
  private func winnerTextView() -> some View {
    if let winnerID = game.winnerID,
       let winner = setEntrants.first(where: { $0.id == winnerID }),
       let name = winner.name {
      if let teamName = winner.teamName {
        Text("Winner: ") + Text(teamName).foregroundColor(.gray) + Text(" ") + Text(name)
      } else {
        Text("Winner: ") + Text(name)
      }
    } else {
      Text("")
    }
  }
}

#Preview {
  PhaseGroupSetGameRowView(
    game: MockStartggService.createPhaseGroupGame(id: 0),
    setEntrants: [MockStartggService.createEntrant(id: 0)]
  )
}
