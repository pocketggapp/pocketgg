import SwiftUI

struct StandingRowView: View {
  private let standing: Standing
  private let progressed: Bool
  
  init(standing: Standing, progressed: Bool) {
    self.standing = standing
    self.progressed = progressed
  }
  
  var body: some View {
    HStack {
      standingTextView
      
      Spacer()
      
      if progressed {
        Text("Progressed")
          .foregroundStyle(.gray)
      }
    }
  }
  
  private var standingTextView: some View {
    if let teamName = standing.entrant?.teamName {
      return Text(placementText) + Text("\(teamName) ").foregroundStyle(.gray) + Text(standing.entrant?.name ?? "")
    } else {
      return Text(placementText) + Text(standing.entrant?.name ?? "")
    }
  }
  
  private var placementText: String {
    guard let placement = standing.placement else { return "" }
    return "\(placement): "
  }
}

#Preview {
  StandingRowView(
    standing: MockStartggService.createStanding(id: 1),
    progressed: true
  )
}
