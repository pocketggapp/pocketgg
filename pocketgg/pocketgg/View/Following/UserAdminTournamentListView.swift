import SwiftUI

struct UserAdminTournamentListView: View {
  @StateObject private var viewModel: UserAdminTournamentListViewModel
  @State private var isRenaming = false
  
  private let user: Entrant
  
  init(
    user: Entrant,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      UserAdminTournamentListViewModel(
        user: user,
        service: service
      )
    }())
    self.user = user
  }
  
  var body: some View {
    List {
      switch viewModel.state {
      case .uninitialized:
        ForEach(0..<20) { _ in
          TournamentRowPlaceholderView()
        }
      case .loaded(let tournaments):
        if !tournaments.isEmpty {
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
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Tournaments",
            subtitle: "There are no tournaments that this user is an an admin of."
          )
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
    .onAppear {
      viewModel.resetFollowingViewRefreshNotification()
    }
    .task {
      await viewModel.fetchTournaments()
    }
    .refreshable {
      await viewModel.fetchTournaments(refreshed: true)
    }
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        Menu {
          Button {
            viewModel.toggleTournamentOrganizerFollowedStatus()
          } label: {
            Label(
              viewModel.isFollowed ? "Unfollow" : "Follow",
              systemImage: viewModel.isFollowed ? "person.fill.badge.minus" : "person.fill.badge.plus"
            )
          }
          
          if viewModel.isFollowed {
            Button {
              isRenaming = true
            } label: {
              Label(
                "Rename",
                systemImage: "rectangle.and.pencil.and.ellipsis"
              )
            }
          }
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
    }
    .alert("Rename", isPresented: $isRenaming) {
      TextField("Prefix", text: $viewModel.customPrefix, prompt: Text(user.teamName ?? "Prefix"))
      TextField("Name", text: $viewModel.customName, prompt: Text(user.name ?? "Name"))
      Button("OK", action: rename)
      Button("Cancel", role: .cancel, action: cancel)
    } message: {
      Text("Enter a new display name for this tournament organizer. This change will only be visible to you.")
    }
    .navigationTitle(viewModel.navigationTitle)
  }
  
  // MARK: Rename Tournament Organizer
  
  private func rename() {
    viewModel.renameTournamentOrganizer()
  }
  
  private func cancel() {
    viewModel.cancelTournamentOrganizerRename()
  }
}

#Preview {
  UserAdminTournamentListView(
    user: MockStartggService.createEntrant(id: 0),
    service: MockStartggService()
  )
}
