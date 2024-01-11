import SwiftUI

struct TournamentHorizontalListView: View {
  var tournamentsGroup: TournamentsGroup

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(tournamentsGroup.name)
          .font(.headline)
        
        Spacer()
        
        if tournamentsGroup.tournaments.count > 10 {
          Button {
            // TODO: Launch list of tournaments
          } label: {
            Text("View all")
          }
        }
      }
      .padding([.horizontal])
      
      ScrollView(.horizontal, showsIndicators: true) {
        HStack(alignment: .top) {
          Spacer()
          ForEach(tournamentsGroup.tournaments) { tournament in
            NavigationLink(value: tournament) {
              TournamentTileView(
                imageURL: tournament.imageURL,
                name: tournament.name,
                date: tournament.date
              )
              .contextMenu {
                Button {
                  // TODO: Open tournament
                } label: {
                  Label("Open", systemImage: "rectangle.portrait.and.arrow.right.fill")
                }
                
                Button {
                  // TODO: Pin/unpin tournament
                } label: {
                  // TODO: Change text/image based on whether the tournament is already pinned or not
                  Label("Pin", systemImage: "pin.fill")
                }
              } preview: {
                // BUG: When the tournament name is too long, the padding of the context menu preview is incorrect
                //      and the tournament name is forced into only 1 line
                TournamentHeaderView(
                  viewModel: TournamentHeaderViewModel(
                    id: tournament.id,
                    name: tournament.name,
                    imageURL: tournament.imageURL,
                    date: tournament.date
                  )
                )
                .padding()
              }
            }
          }
          Spacer()
        }
      }
    }
  }
}

#Preview {
  let image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s"
  let date = "Jul 21 - Jul 23, 2023"
  return TournamentHorizontalListView(
    tournamentsGroup: TournamentsGroup(name: "Test Group", tournaments: [
      TournamentData(id: 0, name: "Tournament 0", imageURL: image, date: date),
      TournamentData(id: 1, name: "Tournament 1", imageURL: image, date: date),
      TournamentData(id: 2, name: "Tournament 2", imageURL: image, date: date),
    ])
  )
}
