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
        ForEach(0..<10) { _ in
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
          ContentUnavailableView(
            "No Events",
            systemImage: "questionmark.app.dashed",
            description: Text("There are currently no events for this tournament.")
          )
        }
      case .error(let is503):
        ErrorStateView(is503: is503, subtitle: "There was an error loading this tournament.") {
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
