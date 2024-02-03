import SwiftUI
import MapKit

struct TournamentView: View {
  @StateObject private var viewModel: TournamentViewModel
  @State private var selected: String
  private var tournament: Tournament
  
  init(
    tournament: Tournament,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      TournamentViewModel(
        tournament: tournament,
        service: service
      )
    }())
    self._selected = State(initialValue: "Events")
    self.tournament = tournament
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        TournamentHeaderView(
          name: tournament.name,
          imageURL: tournament.imageURL,
          date: tournament.date,
          location: tournament.location
        )
        .padding()
        
        SegmentedControlView(
          selected: $selected,
          sections: ["Events", "Streams", "Location", "Contact Info"]
        )
        
        switch selected {
        case "Events":
          EventsView(state: $viewModel.state) {
            reloadTournament()
          }
        case "Streams":
          StreamsView(state: $viewModel.state) {
            reloadTournament()
          }
        case "Location":
          LocationView(state: $viewModel.state, tournamentID: tournament.id) {
            reloadTournament()
          }
        case "Contact Info":
          ContactInfoView(state: $viewModel.state) {
            reloadTournament()
          }
        default:
          EmptyView()
        }
      }
    }
    .task {
      await viewModel.fetchTournament()
    }
    .refreshable {
      await viewModel.fetchTournament(refreshed: true)
    }
    .navigationTitle(tournament.name ?? "")
    .navigationDestination(for: Event.self) { event in
      EventView(event: event)
    }
  }
  
  // MARK: Reload Tournament
  
  private func reloadTournament() {
    Task {
      await viewModel.fetchTournament(refreshed: true)
    }
  }
}

#Preview {
  let image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s"
  let date = "Jul 21 - Jul 23, 2023"
  return TournamentView(
    tournament: Tournament(id: 0, name: "Tournament 0", imageURL: image, date: date, location: "Somewhere"),
    service: MockStartggService()
  )
}
