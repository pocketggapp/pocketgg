import SwiftUI
import StartggAPI

enum HomeViewState {
  case uninitialized
  case loading
  case loaded([TournamentsGroup])
  case error(String)
}

final class HomeViewModel: ObservableObject {
  @Published var state: HomeViewState
  
  private let service: StartggServiceType
  
  init(service: StartggServiceType = StartggService.shared) {
    self.state = .uninitialized
    self.service = service
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let tournaments = try await service.getFeaturedTournaments(pageNum: 1, gameIDs: [1])
      state = .loaded([TournamentsGroup(name: "Featured", tournaments: tournaments)])
    } catch {
      state = .error(error.localizedDescription)
    }
  }
}
