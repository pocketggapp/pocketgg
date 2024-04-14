import CoreData

final class FollowedTOsService {
  static func tournamentOrganizerIsFollowed(
    id: Int,
    coreDataService: CoreDataService = .shared
  ) throws -> Bool {
    let tournamentOrganizerEntities = try getTournamentOrganizers()
    return tournamentOrganizerEntities.contains { $0.id == id }
  }
  
  static func toggleTournamentOrganizerFollowedStatus(
    tournamentOrganizer: Entrant,
    coreDataService: CoreDataService = .shared
  ) throws -> Bool {
    var tournamentOrganizerEntities = try getTournamentOrganizers()
    
    if let index = tournamentOrganizerEntities.firstIndex(where: { $0.id == tournamentOrganizer.id }) {
      // Delete existing tournament organizer entity
      let entity = tournamentOrganizerEntities.remove(at: index)
      coreDataService.context.delete(entity)
      // Save the change in Core Data
      coreDataService.save()
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
      return true
    }
  }
  
  static func getTournamentOrganizers(coreDataService: CoreDataService = .shared) throws -> [TournamentOrganizerEntity] {
    let request = NSFetchRequest<TournamentOrganizerEntity>(entityName: "TournamentOrganizerEntity")
    return try coreDataService.context.fetch(request)
  }
  
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
