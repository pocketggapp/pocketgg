import SwiftUI

struct RoundRobinEntrantView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let entrant: Entrant
  
  init(entrant: Entrant) {
    self.entrant = entrant
  }
  
  var body: some View {
    getEntrantTextView()
      .font(.headline)
      .lineLimit(1)
      .padding()
      .frame(width: RoundRobinBracketView.setWidth * scale)
  }
  
  private func getEntrantTextView() -> some View {
    if let name = entrant.name {
      if let teamName = entrant.teamName {
        return Text(teamName).foregroundStyle(.gray) + Text(" ") + Text(name)
      } else {
        return Text(name)
      }
    } else {
      return Text("_")
    }
  }
}

#Preview {
  RoundRobinEntrantView(
    entrant: MockStartggService.createEntrant(id: 0)
  )
}
