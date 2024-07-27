import SwiftUI

enum PhaseGroupSetViewState {
  case uninitialized
  case loading
  case loaded(PhaseGroupSetDetails?)
  case error
}

final class PhaseGroupSetViewModel: ObservableObject {
  @Published var state: PhaseGroupSetViewState
  
  private let id: Int
  private let service: StartggServiceType
  
  init(
    id: Int,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.id = id
    self.service = service
  }
  
  // MARK: Fetch Phase Group Set
  
  @MainActor
  func fetchPhaseGroupSet(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let phaseGroupSetDetails = try await service.getPhaseGroupSetDetails(id: id)
      state = .loaded(phaseGroupSetDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
