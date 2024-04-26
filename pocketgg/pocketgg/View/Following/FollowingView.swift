import SwiftUI

struct FollowingView: View {
  @StateObject private var viewModel: FollowingViewModel
  
  init() {
    self._viewModel = StateObject(wrappedValue: {
      FollowingViewModel()
    }())
  }
  
  var body: some View {
    NavigationStack {
      List {
        switch viewModel.state {
        case .uninitialized:
          ForEach(0..<20) { _ in
            Text("Tournament Organizer Placeholder")
              .redacted(reason: .placeholder)
          }
        case .loaded:
          if !viewModel.tournamentOrganizers.isEmpty {
            ForEach(viewModel.tournamentOrganizers, id: \.id) { tournamentOrganizer in
              NavigationLink(value: tournamentOrganizer) {
                OrganizerTextView(tournamentOrganizer)
              }
            }
            .onMove(perform: viewModel.moveTournamentOrganizer)
            .onDelete(perform: viewModel.deleteTournamentOrganizer)
          } else {
            EmptyStateView(
              systemImageName: "person.fill.questionmark",
              title: "No tournament organizers followed",
              subtitle: """
              To follow a tournament organizer, tap the Info section on any tournament page, tap the tournament organizer's name, \
              tap the ellipsis at the top right, then tap Follow.
              """
            )
          }
        }
      }
      .listStyle(.insetGrouped)
      .onReceive(NotificationCenter.default.publisher(for: Notification.Name(Constants.refreshFollowingView))) { _ in
        viewModel.needsRefresh = true
      }
      .onAppear {
        viewModel.initializeSections()
      }
      .toolbar { EditButton() }
      .navigationTitle("Following")
      .navigationDestination(for: TournamentOrganizer.self) {
        UserAdminTournamentListView(
          user: Entrant(id: $0.id, name: $0.name, teamName: $0.prefix)
        )
      }
    }
  }
  
  private func OrganizerTextView(_ tournamentOrganizer: TournamentOrganizer) -> some View {
    let formattedName = tournamentOrganizer.formattedName()
    return Text("\(formattedName.prefix) ").foregroundColor(.gray) + Text(formattedName.name)
  }
}

#Preview {
  FollowingView()
}
