import SwiftUI

enum PhaseGroupListViewState {
  case uninitialized
  case loading
  case loaded([PhaseGroup]?)
  case error
}

final class PhaseGroupListViewModel: ObservableObject {
  @Published var state: PhaseGroupListViewState
  
  private let phase: Phase
  private let service: StartggServiceType
  
  init(
    phase: Phase,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.phase = phase
    self.service = service
  }
  
  var headerSubtitleText: String {
    var text = ""
    var components = [String]()
    if let numEntrants = phase.numEntrants {
      components.append("\(numEntrants) entrants")
    }
    if let numPools = phase.numPhaseGroups {
      components.append("\(numPools) pools")
    }
    if let bracketType = phase.bracketType {
      components.append(bracketType.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
    }
    for component in components {
      if !text.isEmpty {
        text += " • "
      }
      text += component
    }
    return text
  }
  
  // MARK: Fetch Phase Groups
  
  @MainActor
  func fetchPhaseGroups(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let phaseGroups = try await service.getPhaseGroups(id: phase.id, numPhaseGroups: phase.numPhaseGroups ?? 90)
      state = .loaded(phaseGroups)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
