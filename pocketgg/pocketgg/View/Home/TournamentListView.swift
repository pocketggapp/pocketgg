import SwiftUI

struct TournamentListView: View {
  @StateObject private var viewModel: TournamentListViewModel
  
  private let title: String
  
  init(
    title: String,
    sectionID: Int,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      TournamentListViewModel(
        sectionID: sectionID,
        service: service
      )
    }())
    self.title = title
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
    .navigationTitle(title)
  }
}

#Preview {
  TournamentListView(
    title: "Tournaments",
    sectionID: -2,
    service: MockStartggService()
  )
}
