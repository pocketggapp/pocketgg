import SwiftUI

struct BracketsView: View {
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
        ForEach(1..<10) { _ in
          TextPlaceholderView()
        }
      case .loaded(let eventDetails):
        if let brackets = eventDetails?.phases, !brackets.isEmpty {
          ForEach(brackets, id: \.id) { bracket in
            NavigationLink(value: bracket) {
              BracketRowView(name: bracket.name)
            }
            .buttonStyle(.plain)
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Brackets",
            subtitle: "There are currently no brackets for this event."
          )
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading this event.") {
          reloadEvent()
        }
      }
    }
    .padding()
  }
}

#Preview {
  let eventDetails = EventDetails(
    phases: [MockStartggService.createPhase()],
    topStandings: []
  )
  return BracketsView(
    state: .constant(.loaded(eventDetails)),
    reloadEvent: { }
  )
}
