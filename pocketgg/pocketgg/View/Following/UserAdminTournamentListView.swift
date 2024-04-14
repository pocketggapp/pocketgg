import SwiftUI

struct UserAdminTournamentListView: View {
  @StateObject private var viewModel: UserAdminTournamentListViewModel
  
  private let title: String
  
  init(
    title: String,
    user: Entrant,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      UserAdminTournamentListViewModel(
        user: user,
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
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        Button(viewModel.isFollowed ? "Unfollow" : "Follow") {
          viewModel.toggleTournamentOrganizerFollowedStatus()
        }
      }
    }
    .navigationTitle(title)
  }
}

#Preview {
  UserAdminTournamentListView(
    title: "C9 Mang0",
    user: MockStartggService.createEntrant(id: 0),
    service: MockStartggService()
  )
}
