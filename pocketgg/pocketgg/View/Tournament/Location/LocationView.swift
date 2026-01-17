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
          ContentUnavailableView(
            "Online",
            systemImage: "wifi.router",
            description: Text("This tournament is being held online.")
          )
        }
      case .error(let is503):
        ErrorStateView(is503: is503, subtitle: "There was an error loading this tournament.") {
          reloadTournament()
        }
      }
    }
    .padding(.bottom)
  }
}

#Preview {
  LocationView(
    state: .constant(.loaded(MockStartggService.createTournamentDetails())),
    tournamentID: 1,
    reloadTournament: { }
  )
}
