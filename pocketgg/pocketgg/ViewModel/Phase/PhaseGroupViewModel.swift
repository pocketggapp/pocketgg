import SwiftUI

enum PhaseGroupViewState {
  case uninitialized
  case loading
  case loaded(PhaseGroupDetails?)
  case error(is503: Bool)
}

final class PhaseGroupViewModel: ObservableObject {
  @Published var state: PhaseGroupViewState
  @Published var additionalStandings: [Standing]
  
  private var phaseGroupID: Int?
  private let phaseID: Int?
  private let service: StartggServiceType
  
  private var currentStandingsPage: Int
  var noMoreStandings: Bool
  
  init(
    phaseGroupID: Int?,
    phaseID: Int?,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.phaseGroupID = phaseGroupID
    self.phaseID = phaseID
    self.service = service
    
    self.additionalStandings = []
    self.currentStandingsPage = 1
    self.noMoreStandings = false
  }
  
  // MARK: Fetch Phase Group
  
  @MainActor
  func fetchPhaseGroup(refreshed: Bool = false) async {
    guard let phaseGroupID else { return }
    
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    } else {
      additionalStandings.removeAll(keepingCapacity: true)
      currentStandingsPage = 1
      noMoreStandings = false
    }
    
    state = .loading
    do {
      var phaseGroupDetails = try await service.getPhaseGroupDetails(id: phaseGroupID)
      await getAdditionalInformation(id: phaseGroupID, phaseGroupDetails: &phaseGroupDetails)
      
      if phaseGroupDetails?.standings.count ?? 0 <= 65 {
        noMoreStandings = true
      }
      state = .loaded(phaseGroupDetails)
    } catch {
      state = .error(is503: error.is503Error)
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
    } else {
      additionalStandings.removeAll(keepingCapacity: true)
      currentStandingsPage = 1
      noMoreStandings = false
    }
    
    state = .loading
    do {
      let phaseGroup = try await service.getPhaseGroups(id: phaseID, numPhaseGroups: 1)
      guard let phaseGroup, let id = phaseGroup.first?.id else {
        state = .loaded(nil)
        return
      }
      self.phaseGroupID = id
      
      var phaseGroupDetails = try await service.getPhaseGroupDetails(id: id)
      await getAdditionalInformation(id: id, phaseGroupDetails: &phaseGroupDetails)
      
      if phaseGroupDetails?.standings.count ?? 0 <= 65 {
        noMoreStandings = true
      }
      state = .loaded(phaseGroupDetails)
    } catch {
      state = .error(is503: error.is503Error)
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Additional Information
  
  private func getAdditionalInformation(id: Int, phaseGroupDetails: inout PhaseGroupDetails?) async {
    guard var sets = phaseGroupDetails?.matches else { return }
    
    // Fetch additional PhaseGroupSets
    // If 90 sets were returned, there may be more sets in total, so load the next page of sets
    if sets.count == 90 {
      let additionalSets = await fetchAdditionalPhaseGroupSets(id: id, pageNum: 2)
      sets.append(contentsOf: additionalSets)
    }
    
    // In the case of a grand finals reset, the 2nd grand finals may have the same roundNum as the 1st grand finals set
    // Therefore, if a set is detected with identical previous round IDs (meaning that the set is a grand finals reset), increment the roundNum
    switch phaseGroupDetails?.bracketType {
    case .singleElimination, .doubleElimination:
      for (i, set) in sets.enumerated() {
        guard set.prevRoundIDs.count == 2 else { continue }
        if set.prevRoundIDs[0] == set.prevRoundIDs[1] {
          sets[i].roundNum += 1
        }
      }
    default:
      break
    }
    phaseGroupDetails?.matches = sets
    
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
          state = .error(is503: error.is503Error)
        }
        #if DEBUG
        print(error.localizedDescription)
        #endif
      }
    }
    return []
  }
  
  @MainActor
  func fetchAdditionalPhaseGroupStandings() async {
    guard let phaseGroupID else { return }
    
    if noMoreStandings { return }
    
    currentStandingsPage += 1
    
    do {
      let standings = try await service.getPhaseGroupStandings(id: phaseGroupID, page: currentStandingsPage)
      guard let standings else {
        noMoreStandings = true
        return
      }
      
      if !standings.isEmpty {
        additionalStandings.append(contentsOf: standings)
      }
      if standings.count < 65 {
        noMoreStandings = true
      }
    } catch {
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
