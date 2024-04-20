import SwiftUI
import CoreData

enum FollowingViewState {
  case uninitialized
  case loaded
}

final class FollowingViewModel: ObservableObject {
  @Published var state: FollowingViewState
  @Published var tournamentOrganizers: [TournamentOrganizer]
  
  private let userDefaults: UserDefaults
  private let coreDataService: CoreDataService
  
  /// FollowingView needs to be refreshed if a tournament organizer is followed/unfollowed
  var needsRefresh = false
  
  private var tournamentOrganizerEntities: [TournamentOrganizerEntity]
  private var tournamentOrganizerLayout: [Int]
  
  init(
    userDefaults: UserDefaults = .standard,
    coreDataService: CoreDataService = .shared
  ) {
    self.state = .uninitialized
    self.tournamentOrganizers = []
    self.userDefaults = userDefaults
    self.coreDataService = coreDataService
    self.tournamentOrganizerEntities = []
    self.tournamentOrganizerLayout = []
  }
  
  func initializeSections() {
    switch state {
    case .uninitialized:
      break
    default:
      if needsRefresh {
        needsRefresh = false
        break
      } else {
        return
      }
    }
    
    getTournamentOrganizers()
    getTournamentOrganizerLayout()
    
    tournamentOrganizers = tournamentOrganizerLayout.compactMap { id -> TournamentOrganizer? in
      guard let entity = tournamentOrganizerEntities.first(where: { $0.id == id }) else { return nil }
      return TournamentOrganizer(
        id: Int(entity.id),
        name: entity.name,
        prefix: entity.prefix,
        customName: entity.customName,
        customPrefix: entity.customPrefix
      )
    }
    
    state = .loaded
  }
  
  // MARK: Get Followed Tournament Organizers
  
  private func getTournamentOrganizerLayout() {
    tournamentOrganizerLayout = userDefaults.array(forKey: Constants.followedTournamentOrganizerIDs) as? [Int] ?? []
  }
  
  func getTournamentOrganizers() {
    do {
      tournamentOrganizerEntities = try FollowedTOsService.getTournamentOrganizers()
    } catch {
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Edit Followed Tournament Organizers
  
  func deleteTournamentOrganizer(at offsets: IndexSet) {
    let index = offsets[offsets.startIndex]
    let deletedTournamentOrganizer = tournamentOrganizers.remove(at: index)
    
    if let entity = tournamentOrganizerEntities.first(where: { $0.id == deletedTournamentOrganizer.id }) {
      coreDataService.context.delete(entity)
      // Save the change in Core Data
      coreDataService.save()
    }
    
    if let idIndex = tournamentOrganizerLayout.firstIndex(of: deletedTournamentOrganizer.id) {
      tournamentOrganizerLayout.remove(at: idIndex)
      updateTournamentOrganizerLayout()
    }
  }
  
  func moveTournamentOrganizer(from source: IndexSet, to destination: Int) {
    tournamentOrganizers.move(fromOffsets: source, toOffset: destination)
    tournamentOrganizerLayout.move(fromOffsets: source, toOffset: destination)
    updateTournamentOrganizerLayout()
  }
  
  func updateTournamentOrganizerLayout() {
    userDefaults.set(tournamentOrganizerLayout, forKey: Constants.followedTournamentOrganizerIDs)
  }
}
