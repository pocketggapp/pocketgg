import SwiftUI

struct EventView: View {
  @ScaledMetric private var scale: CGFloat = 1
  
  @StateObject private var viewModel: EventViewModel
  @State private var selected: String
  
  private let event: Event
  
  init(
    event: Event,
    service: StartggServiceType = StartggService.shared
  ) {
    self._viewModel = StateObject(wrappedValue: {
      EventViewModel(
        event: event,
        service: service
      )
    }())
    self._selected = State(initialValue: "Brackets")
    self.event = event
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        EventHeaderView(
          name: event.name,
          imageURL: event.videogameImage,
          eventType: event.eventType,
          videogameName: event.videogameName,
          startDate: event.startDate,
          dotColor: viewModel.headerDotColor
        )
        .padding()
        
        SegmentedControlView(
          selected: $selected,
          sections: ["Brackets", "Standings"]
        )
        
        switch selected {
        case "Brackets":
          BracketsView(state: $viewModel.state) {
            reloadEvent()
          }
        case "Standings":
          TopStandingsView(state: $viewModel.state) {
            reloadEvent()
          }
        default:
          EmptyView()
        }
      }
    }
    .task {
      await viewModel.fetchEvent()
    }
    .refreshable {
      await viewModel.fetchEvent(refreshed: true)
    }
    .navigationTitle(event.name ?? "")
    .navigationDestination(for: Phase.self) { phase in
      if let numPhaseGroups = phase.numPhaseGroups, numPhaseGroups == 1 {
        EmptyView() // TODO: Single phase group
      } else {
        PhaseGroupListView(phase: phase)
      }
    }
    .navigationDestination(for: EventDetails.self) { _ in
      AllStandingsView(eventID: event.id)
    }
  }
  
  // MARK: Reload Event
  
  private func reloadEvent() {
    Task {
      await viewModel.fetchEvent(refreshed: true)
    }
  }
}

#Preview {
  EventView(
    event: MockStartggService.createEvent(),
    service: MockStartggService()
  )
}
