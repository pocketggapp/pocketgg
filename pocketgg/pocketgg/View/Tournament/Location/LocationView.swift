import SwiftUI

struct LocationView: View {
  @Binding private var state: TournamentViewState
  private let tournamentID: Int
  private let reloadTournament: (() -> Void)
  
  init(
    state: Binding<TournamentViewState>,
    tournamentID: Int,
    reloadTournament: @escaping () -> Void
  ) {
    self._state = state
    self.tournamentID = tournamentID
    self.reloadTournament = reloadTournament
  }
  
  var body: some View {
    VStack {
      switch state {
      case .uninitialized, .loading:
        LocationPlaceholderView()
      case .loaded(let tournamentDetails):
        if let location = tournamentDetails?.location {
          TournamentLocationView(
            tournamentID: tournamentID,
            location: location
          )
        } else {
          EmptyStateView(
            systemImageName: "wifi",
            title: "Online",
            subtitle: "This tournament is being held online"
          )
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading this tournament") {
          reloadTournament()
        }
      }
    }
  }
}

#Preview {
  let tournamentDetails = TournamentDetails(
    events: [],
    streams: [],
    location: MockStartggService.createLocation(),
    contact: (nil, nil)
  )
  return LocationView(
    state: .constant(.loaded(tournamentDetails)),
    tournamentID: 1,
    reloadTournament: { }
  )
}
