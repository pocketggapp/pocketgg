import SwiftUI

struct UserTournamentListView: View {
  @StateObject private var viewModel: UserTournamentListViewModel
  @State private var selected = 0
  @State private var isRenaming = false
  
  private let user: Entrant
  
  init(
    user: Entrant,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      UserTournamentListViewModel(
        user: user,
        service: service
      )
    }())
    self.user = user
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Divider()
      
      InlineTabsView(
        tabIndex: $selected,
        models: [
          .init(title: "Organizer"),
          .init(title: "Admin"),
          .init(title: "Competitor")
        ]
      )
      
      List {
        switch viewModel.state {
        case .uninitialized, .loading:
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
                    await viewModel.fetchTournaments(getNextPage: true, index: selected)
                  }
                }
            }
          } else {
            ContentUnavailableView(
              "No Tournaments",
              systemImage: "questionmark.app.dashed",
              description: Text("There are no tournaments that match the selected filter for this user.")
            )
          }
        case .error(let is503):
          ErrorStateView(is503: is503, subtitle: "There was an error loading tournaments.") {
            Task {
              await viewModel.fetchTournaments(refreshed: true, index: selected)
            }
          }
        }
      }
      .listStyle(.grouped)
      .refreshable {
        await viewModel.fetchTournaments(refreshed: true, index: selected)
      }
    }
    .onAppear {
      viewModel.resetFollowingViewRefreshNotification()
    }
    .task {
      await viewModel.fetchTournaments(index: selected)
    }
    .onChange(of: selected, { _, role in
      Task {
        await viewModel.fetchTournaments(refreshed: true, index: role)
      }
    })
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
  UserTournamentListView(
    user: MockStartggService.createEntrant(id: 0),
    service: MockStartggService()
  )
}
