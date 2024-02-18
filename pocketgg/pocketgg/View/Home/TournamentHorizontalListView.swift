import SwiftUI

struct TournamentHorizontalListView: View {
  var tournamentsGroup: TournamentsGroup
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(tournamentsGroup.name)
          .font(.title2.bold())
        
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
              TournamentTileView(tournament: tournament)
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
                  TournamentContextMenuPreview(tournament: tournament)
                    .padding()
                }
            }
            .buttonStyle(.plain)
          }
          Spacer()
        }
      }
    }
  }
}

#Preview {
  return TournamentHorizontalListView(
    tournamentsGroup: TournamentsGroup(name: "Test Group", tournaments: [
      MockStartggService.createTournament(id: 0),
      MockStartggService.createTournament(id: 1),
      MockStartggService.createTournament(id: 2),
    ])
  )
}
