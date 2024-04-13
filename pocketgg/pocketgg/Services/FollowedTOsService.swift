import CoreData

final class FollowedTOsService {
  // TODO: Finish this
  static func getTournamentOrganizers(coreDataService: CoreDataService = .shared) throws -> [TournamentOrganizerEntity] {
    let request = NSFetchRequest<TournamentOrganizerEntity>(entityName: "TournamentOrganizerEntity")
    return try coreDataService.context.fetch(request)
  }
}
