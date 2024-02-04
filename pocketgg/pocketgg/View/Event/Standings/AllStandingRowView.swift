import SwiftUI

struct AllStandingRowView: View {
  private var standing: Standing
  
  init(standing: Standing) {
    self.standing = standing
  }
  
  var body: some View {
    standingTextView
      .font(.body)
  }
  
  private var standingTextView: some View {
    if let teamName = standing.entrant?.teamName {
      return Text(placementText) + Text("\(teamName) ").foregroundColor(.gray) + Text(standing.entrant?.name ?? "")
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
  AllStandingRowView(
    standing: MockStartggService.createStanding(id: 1)
  )
}
