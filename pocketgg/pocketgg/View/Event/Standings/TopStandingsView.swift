import SwiftUI

struct TopStandingsView: View {
  @Binding private var state: EventViewState
  
  private let reloadEvent: (() -> Void)
  
  init(state: Binding<EventViewState>, reloadEvent: @escaping () -> Void) {
    self._state = state
    self.reloadEvent = reloadEvent
  }
  
  var body: some View {
    VStack {
      switch state {
      case .uninitialized, .loading:
        ForEach(0..<10) { _ in
          TextPlaceholderView()
        }
      case .loaded(let eventDetails):
        if let standings = eventDetails?.topStandings, !standings.isEmpty {
          ForEach(standings, id: \.id) { standing in
            TopStandingRowView(standing: standing)
          }
          
          if standings.count == 8 {
            NavigationLink(value: eventDetails) {
              HStack {
                Image(systemName: "list.number")
                
                Text("View all standings")
                  .font(.body)
                
                Spacer()
              }
            }
            .padding(.top)
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Standings",
            subtitle: "There are currently no standings for this event."
          )
        }
      case .error(let is503):
        ErrorStateView(is503: is503, subtitle: "There was an error loading this event.") {
          reloadEvent()
        }
      }
    }
    .padding()
  }
}

#Preview {
  let eventDetails = EventDetails(
    phases: [],
    topStandings: MockStartggService.createStandings()
  )
  return TopStandingsView(
    state: .constant(.loaded(eventDetails)),
    reloadEvent: { }
  )
}
