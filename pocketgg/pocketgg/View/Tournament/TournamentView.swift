import SwiftUI
import MapKit

struct TournamentView: View {
  @StateObject private var viewModel: TournamentViewModel
  @State private var selected: String
  
  private let tournament: Tournament
  
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
        TournamentHeaderView(tournament: tournament)
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
  return TournamentView(
    tournament: MockStartggService.createTournament(id: 0),
    service: MockStartggService()
  )
}
