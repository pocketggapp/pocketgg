import SwiftUI

struct TournamentsPlaceholderView: View {

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Super Smash Bros. Melee")
          .font(.title2.bold())
        
        Spacer()
      }
      .padding(.horizontal)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top) {
          Spacer()
          ForEach(0..<5) { _ in
            TournamentTilePlaceholderView()
          }
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
