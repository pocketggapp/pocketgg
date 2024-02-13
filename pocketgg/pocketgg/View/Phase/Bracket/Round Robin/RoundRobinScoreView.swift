import SwiftUI

struct RoundRobinScoreView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  private let score: (String, String)
  
  init(score: (String, String)) {
    self.score = score
  }
  
  var body: some View {
    VStack {
      Text(score.0)
        .font(.headline)
      
      Text(score.1)
        .font(.headline)
        .foregroundColor(.gray)
    }
    .frame(width: RoundRobinBracketView.setWidth * scale)
  }
}

#Preview {
  RoundRobinScoreView(
    score: ("8 - 0", "10 - 1")
  )
}
