import SwiftUI

struct TournamentTilePlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading) {
      Rectangle()
        .fill(Color(.placeholder))
        .frame(width: 250 * scale, height: 125 * scale)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      
      VStack(alignment: .leading, spacing: 5) {
        Text("The Big House 6")
          .font(.headline)
          .lineLimit(1)
        
        Text("Oct 7, 2019 - Oct 9, 2016")
          .font(.subheadline)
        
        Text("Dearborn, MI, USA")
          .font(.subheadline)
      }
    }
    .redacted(reason: .placeholder)
  }
}

#Preview {
  TournamentTilePlaceholderView()
}
