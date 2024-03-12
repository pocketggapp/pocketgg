import SwiftUI

struct EventsView: View {
  @Binding private var state: TournamentViewState
  
  private let reloadTournament: (() -> Void)
  
  init(state: Binding<TournamentViewState>, reloadTournament: @escaping () -> Void) {
    self._state = state
    self.reloadTournament = reloadTournament
  }
  
  var body: some View {
    VStack {
      switch state {
      case .uninitialized, .loading:
        ForEach(1..<10) { _ in
          EventPlaceholderView()
        }
      case .loaded(let tournamentDetails):
        if let events = tournamentDetails?.events, !events.isEmpty {
          ForEach(events, id: \.id) { event in
            NavigationLink(value: event) {
              EventRowView(event: event)
            }
            .buttonStyle(.plain)
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Events",
            subtitle: "There are currently no events for this tournament"
          )
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading this tournament") {
          reloadTournament()
        }
      }
    }
    .padding()
  }
}

#Preview {
  EventsView(
    state: .constant(.loaded(MockStartggService.createTournamentDetails())),
    reloadTournament: { }
  )
}
