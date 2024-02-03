import SwiftUI

enum EventViewState {
  case uninitialized
  case loading
  case loaded(EventDetails?)
  case error
}

final class EventViewModel: ObservableObject {
  @Published var state: EventViewState
  
  private let event: Event
  private let service: StartggServiceType
  
  var headerDotColor: Color {
    switch event.state {
    case "ACTIVE": .green
    case "COMPLETED": .gray
    default: .blue
    }
  }
  
  init(
    event: Event,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.event = event
    self.service = service
  }
  
  // MARK: Fetch Event
  
  @MainActor
  func fetchEvent(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let eventDetails = try await service.getEventDetails(id: event.id)
      state = .loaded(eventDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
