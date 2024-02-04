import SwiftUI

struct TopStandingRowView: View {
  @ScaledMetric private var scale: CGFloat = 1
  private var standing: Standing
  
  init(standing: Standing) {
    self.standing = standing
  }
  
  var body: some View {
    HStack {
      standingTextView
        .font(.body)
        .frame(height: 44 * scale)
      
      Spacer()
    }
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
    switch placement {
    case 0: return ""
    case 1: return "🥇 "
    case 2: return "🥈 "
    case 3: return "🥉 "
    default: return "\(placement):  "
    }
  }
}

#Preview {
  TopStandingRowView(
    standing: Standing(
      entrant: Entrant(id: 0, name: "Mang0", teamName: "C9"),
      placement: 1
    )
  )
}
