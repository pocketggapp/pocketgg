import SwiftUI

struct TournamentRowPlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    HStack(alignment: .top) {
      Rectangle()
        .fill(Color(.placeholder))
        .frame(width: 100 * scale, height: 100 * scale)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      
      VStack(alignment: .leading, spacing: 5) {
        Text("The Big House 6")
          .font(.title2.bold())
        
        Text("Oct 7, 2016 - Oct 9, 2016")
        
        Text("Dearborn, MI, USA")
      }
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  TournamentRowPlaceholderView()
}
