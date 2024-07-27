import SwiftUI

struct CurrentUserTournamentsView: View {
  @StateObject private var viewModel: CurrentUserTournamentsViewModel
  
  init(service: StartggServiceType = StartggService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      CurrentUserTournamentsViewModel(service: service)
    }())
  }
  
  var body: some View {
    List {
      switch viewModel.state {
      case .uninitialized, .loading:
        ForEach(0..<20) { _ in
          TournamentRowPlaceholderView()
        }
      case .loaded(let tournaments):
        ForEach(tournaments, id: \.id) { tournament in
          NavigationLink(value: tournament) {
            TournamentRowView(tournament: tournament)
          }
        }
        
        if !viewModel.noMoreTournaments {
          TournamentRowPlaceholderView()
            .onAppear {
              Task {
                await viewModel.fetchTournaments(getNextPage: true)
              }
            }
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading tournaments.") {
          Task {
            await viewModel.fetchTournaments(refreshed: true)
          }
        }
      }
    }
    .listStyle(.grouped)
    .task {
      await viewModel.fetchTournaments()
    }
    .refreshable {
      await viewModel.fetchTournaments(refreshed: true)
    }
    .navigationTitle("Recent Tournaments")
  }
}

#Preview {
  CurrentUserTournamentsView(
    service: MockStartggService()
  )
}
