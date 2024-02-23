import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  
  init(service: StartggServiceType = StartggService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      HomeViewModel(service: service)
    }())
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 32) {
          switch viewModel.state {
          case .uninitialized, .loading:
            TournamentsPlaceholderView()
            TournamentsPlaceholderView()
            TournamentsPlaceholderView()
          case .loaded(let tournamentGroups):
            ForEach(tournamentGroups) { tournamentGroup in
              TournamentHorizontalListView(tournamentsGroup: tournamentGroup)
            }
          case .error(let error):
            Text(error)
          }
        }
      }
      .task {
        await viewModel.fetchTournaments()
      }
      .refreshable {
        await viewModel.fetchTournaments(refreshed: true)
      }
      .navigationTitle("Tournaments")
      .navigationDestination(for: Tournament.self) { tournament in
        TournamentView(
          tournament: tournament
        )
      }
    }
  }
}

#Preview {
  HomeView(
    service: MockStartggService()
  )
}
