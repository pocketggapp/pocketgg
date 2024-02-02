import SwiftUI

enum EventViewState {
  case uninitialized
  case loading
  case loaded
  case error
}

final class EventViewModel: ObservableObject {
  @Published var state: EventViewState
  private let event: Event
  
  var headerDotColor: Color {
    switch event.state {
    case "ACTIVE": .green
    case "COMPLETED": .gray
    default: .blue
    }
  }
  
  init(_ event: Event) {
    self.state = .uninitialized
    self.event = event
  }
}
