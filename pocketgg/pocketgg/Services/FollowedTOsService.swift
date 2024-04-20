import CoreData

final class FollowedTOsService {
  static func tournamentOrganizerIsFollowed(
    id: Int,
    userDefaults: UserDefaults = .standard
  ) throws -> Bool {
    let tournamentOrganizerIDs = userDefaults.array(forKey: Constants.followedTournamentOrganizerIDs) as? [Int] ?? []
    return tournamentOrganizerIDs.contains(id)
  }
  
  static func toggleTournamentOrganizerFollowedStatus(
    tournamentOrganizer: Entrant,
    userDefaults: UserDefaults = .standard,
    coreDataService: CoreDataService = .shared
  ) throws -> Bool {
    var tournamentOrganizerEntities = try getTournamentOrganizers()
    var tournamentOrganizerIDs = userDefaults.array(forKey: Constants.followedTournamentOrganizerIDs) as? [Int] ?? []
    
    if let index = tournamentOrganizerEntities.firstIndex(where: { $0.id == tournamentOrganizer.id }) {
      // Delete existing tournament organizer entity
      let entity = tournamentOrganizerEntities.remove(at: index)
      coreDataService.context.delete(entity)
      // Save the change in Core Data
      coreDataService.save()
      
      // Save the change in the UserDefaults array for the order of the followed tournament organizers
      if let idIndex = tournamentOrganizerIDs.firstIndex(of: tournamentOrganizer.id) {
        tournamentOrganizerIDs.remove(at: idIndex)
        userDefaults.set(tournamentOrganizerIDs, forKey: Constants.followedTournamentOrganizerIDs)
      }
      return false
    } else {
      // Add tournament organizer entity
      let entity = TournamentOrganizerEntity(context: coreDataService.context)
      entity.id = Int64(tournamentOrganizer.id)
      entity.name = tournamentOrganizer.name
      entity.prefix = tournamentOrganizer.teamName
      entity.customName = nil
      entity.customPrefix = nil
      // Save the change in Core Data
      coreDataService.save()
      
      // Save the change in the UserDefaults array for the order of the followed tournament organizers
      if !tournamentOrganizerIDs.contains(tournamentOrganizer.id) {
        tournamentOrganizerIDs.append(tournamentOrganizer.id)
        userDefaults.set(tournamentOrganizerIDs, forKey: Constants.followedTournamentOrganizerIDs)
      }
      return true
    }
  }
  
  static func getTournamentOrganizers(coreDataService: CoreDataService = .shared) throws -> [TournamentOrganizerEntity] {
    let request = NSFetchRequest<TournamentOrganizerEntity>(entityName: "TournamentOrganizerEntity")
    return try coreDataService.context.fetch(request)
  }
  
  // TODO: Delete along with TESTCoreDataView
  static func deleteAllTournamentOrganizers(coreDataService: CoreDataService = .shared) {
    let request = NSFetchRequest<TournamentOrganizerEntity>(entityName: "TournamentOrganizerEntity")
    
    do {
      let entities = try coreDataService.context.fetch(request)
      for entity in entities {
        coreDataService.context.delete(entity)
      }
      coreDataService.save()
      
    } catch let error {
      print("Error getting tournament organizer entities: \(error)")
    }
  }
}
