import SwiftUI
import MapKit

struct TournamentView: View {
  @StateObject private var viewModel: TournamentViewModel
  @State private var selected: String
  private var tournamentData: TournamentData
  
  init(tournamentData: TournamentData, service: StartggServiceType = StartggService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      TournamentViewModel(
        tournamentData: tournamentData,
        service: service
      )
    }())
    self.selected = "Events"
    self.tournamentData = tournamentData
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        TournamentHeaderView(
          id: tournamentData.id,
          name: tournamentData.name,
          imageURL: tournamentData.imageURL,
          date: tournamentData.date
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
          LocationView(state: $viewModel.state, tournamentID: tournamentData.id) {
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
    .navigationTitle(tournamentData.name)
    .navigationDestination(for: Event.self) { event in
      EmptyView() // TODO: EventView
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
    tournamentData: TournamentData(id: 0, name: "Tournament 0", imageURL: image, date: date),
    service: MockStartggService()
  )
}
