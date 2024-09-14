import SwiftUI

struct EventView: View {
  @ScaledMetric private var scale: CGFloat = 1
  @StateObject private var viewModel: EventViewModel
  @State private var selected = 0
  
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
        
        InlineTabsView(
          tabIndex: $selected,
          models: [
            .init(title: "Brackets"),
            .init(title: "Standings")
          ]
        )
        
        switch selected {
        case 0:
          BracketsView(state: $viewModel.state) {
            reloadEvent()
          }
        case 1:
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
        PhaseGroupView(
          phaseGroup: nil,
          phaseID: phase.id,
          title: phase.name ?? ""
        )
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
