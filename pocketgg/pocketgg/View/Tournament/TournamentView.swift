import SwiftUI

struct TournamentView: View {
  @StateObject private var viewModel: TournamentViewModel
  @State private var selected: String
  private var tournamentData: TournamentData
  
  init(tournamentData: TournamentData, service: StartggServiceType = StartggService.shared) {
    self._viewModel = StateObject(wrappedValue: {
      TournamentViewModel(
        tournamentData: tournamentData,
        service: service
      )
    }())
    self.selected = "Events"
    self.tournamentData = tournamentData
  }
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading) {
        TournamentHeaderView(
          id: tournamentData.id,
          name: tournamentData.name,
          imageURL: tournamentData.imageURL,
          date: tournamentData.date
        )
        .padding()
        
        SegmentedControlView(selected: $selected, sections: ["Events", "Streams", "Location", "Contact Info"])
        
        switch selected {
        case "Events":
          eventsView
        case "Streams":
          Color.blue
        case "Location":
          Color.green
        case "Contact Info":
          Color.purple
        default:
          EmptyView()
        }
      }
    }
    .onAppear {
      viewModel.onViewAppear()
    }
    .navigationTitle(tournamentData.name)
    .navigationDestination(for: Event.self) { event in
      EmptyView() // TODO: EventView
    }
  }
  
  private var eventsView: some View {
    VStack(alignment: .leading) {
      switch viewModel.state {
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
          // TODO: No events view
          EmptyView()
        }
      case .error(let string):
        Text(string)
      }
    }
    .padding()
  }
}

#Preview {
  let image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s"
  let date = "Jul 21 - Jul 23, 2023"
  return TournamentView(
    tournamentData: TournamentData(id: 0, name: "Tournament 0", imageURL: image, date: date),
    service: MockStartggService()
  )
}
