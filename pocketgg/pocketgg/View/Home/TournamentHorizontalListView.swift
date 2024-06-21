import SwiftUI

struct TournamentHorizontalListView: View {
  @State private var showingEditPinnedTournamentsView: Bool
  
  private let tournamentsGroup: TournamentsGroup
  private let reloadHome: (() -> Void)
  
  init(
    tournamentsGroup: TournamentsGroup,
    reloadHome: @escaping () -> Void
  ) {
    self.tournamentsGroup = tournamentsGroup
    self.reloadHome = reloadHome
    self._showingEditPinnedTournamentsView = State(initialValue: false)
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(tournamentsGroup.name)
          .font(.title2.bold())
        
        Spacer()
        
        HeaderButtonView()
      }
      .padding([.horizontal])
      
      if !tournamentsGroup.tournaments.isEmpty {
        ScrollView(.horizontal, showsIndicators: true) {
          HStack(alignment: .top) {
            Spacer()
            ForEach(tournamentsGroup.tournaments, id: \.id) { tournament in
              NavigationLink(value: tournament) {
                TournamentTileView(tournament: tournament)
              }
              .buttonStyle(.plain)
            }
            Spacer()
          }
        }
      } else {
        EmptyStateView(
          systemImageName: "questionmark.app.dashed",
          title: tournamentsGroup.id == -1 ? "No Pinned Tournaments" : "No Tournaments",
          subtitle: tournamentsGroup.id == -1 ? "You have no pinned tournaments." : "No tournaments found for this category.",
          showVerticalPadding: false
        )
      }
    }
    .sheet(isPresented: $showingEditPinnedTournamentsView, onDismiss: {
      reloadHome()
    }, content: {
      EditPinnedTournamentsView(tournamentsGroup.tournaments)
    })
  }
  
  @ViewBuilder
  private func HeaderButtonView() -> some View {
    switch tournamentsGroup.id {
    case -1:
      Button {
        showingEditPinnedTournamentsView = true
      } label: {
        Text("Edit")
      }
    default:
      if tournamentsGroup.tournaments.count >= 10 {
        NavigationLink(value: tournamentsGroup) {
          Text("View all")
        }
      }
    }
  }
}

#Preview {
  return TournamentHorizontalListView(
    tournamentsGroup: MockStartggService.createTournamentsGroup(),
    reloadHome: { }
  )
}
