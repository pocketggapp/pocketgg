import SwiftUI
import MapKit

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
        
        SegmentedControlView(
          selected: $selected,
          sections: ["Events", "Streams", "Location", "Contact Info"]
        )
        
        switch selected {
        case "Events":
          eventsView
        case "Streams":
          streamsView
        case "Location":
          locationView
        case "Contact Info":
          contactInfoView
        default:
          EmptyView()
        }
      }
    }
    .task {
      await viewModel.fetchTournament()
    }
    .refreshable {
      await viewModel.fetchTournament(refreshed: true)
    }
    .navigationTitle(tournamentData.name)
    .navigationDestination(for: Event.self) { event in
      EmptyView() // TODO: EventView
    }
  }
  
  // MARK: Events View
  
  private var eventsView: some View {
    VStack {
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
          NoEventsView()
        }
      case .error(let error):
        ErrorStateView {
          Task {
            await viewModel.fetchTournament(refreshed: true)
          }
          #if DEBUG
          print(error)
          #endif
        }
      }
    }
    .padding()
  }
  
  // MARK: Streams View
  
  private var streamsView: some View {
    VStack {
      switch viewModel.state {
      case .uninitialized, .loading:
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
        StreamPlaceholderView()
      case .loaded(let tournamentDetails):
        if let streams = tournamentDetails?.streams, !streams.isEmpty {
          ForEach(streams) { stream in
            // TODO: Handle stream tapped, might not be navigationlink
            NavigationLink(value: stream) {
              StreamRowView(stream: stream)
            }
            .buttonStyle(.plain)
          }
        } else {
          NoStreamsView()
        }
      case .error(let error):
        ErrorStateView {
          Task {
            await viewModel.fetchTournament(refreshed: true)
          }
          #if DEBUG
          print(error)
          #endif
        }
      }
    }
    .padding()
  }
  
  // MARK: Location View
  
  private var locationView: some View {
    VStack {
      switch viewModel.state {
      case .uninitialized, .loading:
        LocationPlaceholderView()
      case .loaded(let tournamentDetails):
        if let location = tournamentDetails?.location {
          TournamentLocationView(
            tournamentID: tournamentData.id,
            location: location
          )
        } else {
          NoLocationView()
        }
      case .error(let error):
        ErrorStateView {
          Task {
            await viewModel.fetchTournament(refreshed: true)
          }
          #if DEBUG
          print(error)
          #endif
        }
      }
    }
  }
  
  // MARK: Contact Info View
  
  private var contactInfoView: some View {
    VStack {
      switch viewModel.state {
      case .uninitialized, .loading:
        LocationPlaceholderView()
      case .loaded(let tournamentDetails):
        if let contactInfo = tournamentDetails?.contact.info,
           let contactType = tournamentDetails?.contact.type {
          ContactInfoView(contactInfo: contactInfo, contactType: contactType)
        } else {
          NoContactInfoView()
        }
      case .error(let error):
        ErrorStateView {
          Task {
            await viewModel.fetchTournament(refreshed: true)
          }
          #if DEBUG
          print(error)
          #endif
        }
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
