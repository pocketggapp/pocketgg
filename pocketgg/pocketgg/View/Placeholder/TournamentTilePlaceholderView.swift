import SwiftUI

struct TournamentTilePlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading) {
      Rectangle()
        .fill(Color(.placeholder))
        .frame(width: 150 * scale, height: 150 * scale)
        .cornerRadius(10)
      
      Text("The Big House 6")
        .font(.headline)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      Text("Oct 7, 2019 - Oct 9, 2016")
        .font(.subheadline)
        .multilineTextAlignment(.leading)
    }
    .aspectRatio(0.6, contentMode: .fit)
    .frame(width: 150 * scale)
    .redacted(reason: .placeholder)
  }
}

#Preview {
  TournamentTilePlaceholderView()
}
