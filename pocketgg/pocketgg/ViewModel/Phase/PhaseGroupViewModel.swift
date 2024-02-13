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
      var phaseGroupDetails = try await service.getPhaseGroupDetails(id: id)
      await getAdditionalInformation(id: id, phaseGroupDetails: &phaseGroupDetails)
      
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
      
      var phaseGroupDetails = try await service.getPhaseGroupDetails(id: id)
      await getAdditionalInformation(id: id, phaseGroupDetails: &phaseGroupDetails)
      
      state = .loaded(phaseGroupDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Private Helpers
  
  private func getAdditionalInformation(id: Int, phaseGroupDetails: inout PhaseGroupDetails?) async {
    // Fetch additional PhaseGroupSets
    // If 90 sets were returned, there may be more sets in total, so load the next page of sets
    var sets = phaseGroupDetails?.matches
    if sets?.count == 90 {
      let additionalSets = await fetchAdditionalPhaseGroupSets(id: id, pageNum: 2)
      sets?.append(contentsOf: additionalSets)
    }
    
    // Sort the sets by identifier and increment the grand final reset's roundNum (if it exists)
    // TODO: Maybe move this logic to right before the EliminationBracketView is created, as the 'Matches' section prefers the old ordering
    if let normalizedSets = PhaseGroupSetService.normalizeSets(sets: sets, bracketType: phaseGroupDetails?.bracketType) {
      phaseGroupDetails?.matches = normalizedSets
    }
    
    // Generate round labels for all of the sets
    let roundLabels = PhaseGroupSetService.generateRoundLabels(sets: phaseGroupDetails?.matches, bracketType: phaseGroupDetails?.bracketType)
    phaseGroupDetails?.roundLabels = roundLabels ?? []
    
    // Generate a mapping from every set's ID to its roundNum
    var phaseGroupSetRounds = [Int: Int]()
    if let sets = phaseGroupDetails?.matches {
      for set in sets {
        if phaseGroupSetRounds[set.id] == nil {
          phaseGroupSetRounds[set.id] = set.roundNum
        }
      }
    }
    phaseGroupDetails?.phaseGroupSetRounds = phaseGroupSetRounds
  }
  
  private func fetchAdditionalPhaseGroupSets(id: Int, pageNum: Int) async -> [PhaseGroupSet] {
    // Upper limit to prevent potential infinite recursive calls
    if pageNum < 6 {
      do {
        var newSets = try await service.getRemainingPhaseGroupSets(id: id, pageNum: pageNum)
        
        // If more data needs to be loaded, recursively call this function until all of the data is loaded
        if newSets.count == 90 {
          await newSets.append(contentsOf: fetchAdditionalPhaseGroupSets(id: id, pageNum: pageNum + 1))
        }
        
        return newSets
      } catch {
        await MainActor.run {
          state = .error
        }
        #if DEBUG
        print(error.localizedDescription)
        #endif
      }
    }
    return []
  }
}
