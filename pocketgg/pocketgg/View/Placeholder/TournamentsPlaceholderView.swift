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

#Preview {
  TournamentsPlaceholderView()
}
