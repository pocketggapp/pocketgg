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
        StreamPlaceholderView() // TODO: Maybe make generic placeholder views
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
      case .loaded(let eventDetails):
        if let brackets = eventDetails?.phases, !brackets.isEmpty {
          ForEach(brackets) { bracket in
            Text(bracket.name ?? "")
          }
        } else {
          EmptyStateView(
            systemImageName: "questionmark.app.dashed",
            title: "No Brackets",
            subtitle: "There are currently no brackets for this event"
          )
        }
      case .error:
        ErrorStateView(subtitle: "There was an error loading this event") {
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
