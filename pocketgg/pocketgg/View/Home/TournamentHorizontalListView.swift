import SwiftUI

struct TournamentHorizontalListView: View {
  var tournaments: [TournamentData]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: true) {
      HStack(alignment: .top) {
        ForEach(tournaments) { tournament in
          NavigationLink(value: tournament) {
            TournamentTileView(
              imageURL: tournament.imageURL,
              name: tournament.name,
              date: tournament.date
            )
          }
          // TODO: Add support for context menu (may have to replace List in HomeView with ScrollView + (Lazy)VStack to get it to work)
          // https://stackoverflow.com/q/75793978
        }
      }
    }
  }
}
