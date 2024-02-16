import SwiftUI

enum PhaseGroupSetViewState {
  case uninitialized
  case loading
  case loaded([PhaseGroupSetGame])
  case error
}

final class PhaseGroupSetViewModel: ObservableObject {
  @Published var state: PhaseGroupSetViewState
  
  private let phaseGroupSet: PhaseGroupSet?
  private let service: StartggServiceType
  
  init(
    phaseGroupSet: PhaseGroupSet?,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.phaseGroupSet = phaseGroupSet
    self.service = service
  }
  
  // MARK: Fetch Phase Group Set
  
  @MainActor
  func fetchPhaseGroupSet(refreshed: Bool = false) async {
    guard let id = phaseGroupSet?.id else { return }
    
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let phaseGroupSetGames = try await service.getPhaseGroupSetGames(id: id)
      state = .loaded(phaseGroupSetGames)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
