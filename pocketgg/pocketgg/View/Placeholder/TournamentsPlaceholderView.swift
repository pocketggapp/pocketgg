import SwiftUI

struct TournamentsPlaceholderView: View {

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Super Smash Bros. Melee")
          .font(.headline)
        
        Spacer()
      }
      .padding([.horizontal])
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top) {
          Spacer()
          TournamentTilePlaceholderView()
          TournamentTilePlaceholderView()
          TournamentTilePlaceholderView()
          Spacer()
        }
      }
    }
    .redacted(reason: .placeholder)
  }
}

struct TournamentTilePlaceholderView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading) {
      Rectangle()
        .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
        .aspectRatio(1, contentMode: .fit)
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
  TournamentsPlaceholderView()
}
