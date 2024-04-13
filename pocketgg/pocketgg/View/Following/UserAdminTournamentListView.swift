import SwiftUI

struct UserAdminTournamentListView: View {
  @StateObject private var viewModel: UserAdminTournamentListViewModel
  
  private let title: String
  
  init(
    title: String,
    userID: Int,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      UserAdminTournamentListViewModel(
        userID: userID,
        service: service
      )
    }())
    self.title = title
  }
  var body: some View {
    List {
      switch viewModel.state {
      case .uninitialized:
        ForEach(1..<20) { _ in
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
        ErrorStateView(subtitle: "There was an error loading tournaments") {
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
  UserAdminTournamentListView(
    title: "C9 Mang0",
    userID: 0,
    service: MockStartggService()
  )
}
