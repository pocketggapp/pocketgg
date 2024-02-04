import SwiftUI

enum PhaseGroupViewState {
  case uninitialized
  case loading
  case loaded(PhaseGroupDetails?)
  case error
}

final class PhaseGroupViewModel: ObservableObject {
  @Published var state: PhaseGroupViewState
  
  private let phaseGroup: PhaseGroup?
  private let phaseID: Int?
  private let service: StartggServiceType
  
  init(
    phaseGroup: PhaseGroup?,
    phaseID: Int?,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.phaseGroup = phaseGroup
    self.phaseID = phaseID
    self.service = service
  }
  
  // MARK: Fetch Phase Group
  
  @MainActor
  func fetchPhaseGroup(refreshed: Bool = false) async {
    guard let id = phaseGroup?.id else { return }
    
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let phaseGroupDetails = try await service.getPhaseGroupDetails(id: id)
      state = .loaded(phaseGroupDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Fetch Single Phase Group
  
  @MainActor
  func fetchSinglePhaseGroup(refreshed: Bool = false) async {
    guard let phaseID else { return }
    
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let phaseGroup = try await service.getPhaseGroups(id: phaseID, numPhaseGroups: 1)
      guard let phaseGroup, let id = phaseGroup.first?.id else {
        state = .loaded(nil)
        return
      }
      
      let phaseGroupDetails = try await service.getPhaseGroupDetails(id: id)
      state = .loaded(phaseGroupDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
