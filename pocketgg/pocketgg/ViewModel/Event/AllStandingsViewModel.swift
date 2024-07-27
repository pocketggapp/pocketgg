import SwiftUI

enum AllStandingsViewState {
  case uninitialized
  case loading
  case loaded([Standing])
  case error(is503: Bool)
}

final class AllStandingsViewModel: ObservableObject {
  @Published var state: AllStandingsViewState
  
  private let eventID: Int
  private let service: StartggServiceType
  private var accumulatedStandings: [Standing]
  private var currentStandingsPage: Int
  var noMoreStandings: Bool
  
  init(
    eventID: Int,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.eventID = eventID
    self.service = service
    self.accumulatedStandings = []
    self.currentStandingsPage = 1
    self.noMoreStandings = false
  }
  
  // MARK: Fetch Standings
  
  @MainActor
  func fetchStandings(refreshed: Bool = false, getNextPage: Bool = false) async {
    // Ensure the .task modifier in AllStandingsView only gets called once
    if !refreshed, !getNextPage {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    if refreshed {
      accumulatedStandings.removeAll(keepingCapacity: true)
      currentStandingsPage = 1
      noMoreStandings = false
      state = .loading
    }
    if getNextPage {
      currentStandingsPage += 1
    }
    if noMoreStandings { return }
    
    do {
      let standings = try await service.getEventStandings(id: eventID, page: currentStandingsPage)
      guard let standings else {
        state = .loaded(accumulatedStandings)
        noMoreStandings = true
        return
      }
      
      if !standings.isEmpty {
        accumulatedStandings.append(contentsOf: standings)
      }
      if standings.count < 65 {
        noMoreStandings = true
      }
      state = .loaded(accumulatedStandings)
    } catch {
      state = .error(is503: error.is503Error)
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
