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
        EventPlaceholderView()
        EventPlaceholderView()
        EventPlaceholderView()
        EventPlaceholderView()
        EventPlaceholderView()
      case .loaded(let tournamentDetails):
        if let events = tournamentDetails?.events, !events.isEmpty {
          ForEach(events) { event in
            NavigationLink(value: event) {
              EventRowView(event: event)
            }
            .buttonStyle(.plain)
          }
        } else {
          NoEventsView()
        }
      case .error:
        ErrorStateView {
          reloadTournament()
        }
      }
    }
    .padding()
  }
}

#Preview {
  let tournamentDetails = TournamentDetails(
    events: [MockStartggService.createEvent()],
    streams: [],
    location: nil,
    contact: (nil, nil)
  )
  return EventsView(
    state: .constant(.loaded(tournamentDetails)),
    reloadTournament: { }
  )
}
