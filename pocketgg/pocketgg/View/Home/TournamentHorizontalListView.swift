import SwiftUI

struct TournamentHorizontalListView: View {
  var tournaments: [TournamentData]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: true) {
      HStack {
        ForEach(tournaments) { tournament in
          NavigationLink(value: tournament) {
            TournamentTileView(
              imageURL: tournament.imageURL,
              name: tournament.name,
              date: tournament.date
            )
          }
        }
      }
    }
  }
}
