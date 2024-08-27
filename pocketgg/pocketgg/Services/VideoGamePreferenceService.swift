import CoreData

final class VideoGamePreferenceService {
  static func saveVideoGames(gameIDs: Set<Int>, coreDataService: CoreDataService = .shared) {
    let games = convertIDsToVideoGames(ids: gameIDs)
    
    for game in games {
      let newGame = VideoGameEntity(context: coreDataService.context)
      newGame.id = Int64(game.id)
      newGame.name = game.name
    }
    
    coreDataService.save()
  }
  
  static func getVideoGames(coreDataService: CoreDataService = .shared) throws -> [VideoGameEntity] {
    let request = NSFetchRequest<VideoGameEntity>(entityName: "VideoGameEntity")    
    return try coreDataService.context.fetch(request)
  }
  
  static func getRecommendedGames() -> [VideoGame] {
    // Periodically check list of recommended video games
    [
      VideoGame(id: 1, name: "Super Smash Bros. Melee"),
      VideoGame(id: 1386, name: "Super Smash Bros. Ultimate"),
      VideoGame(id: 14, name: "Rocket League"),
      VideoGame(id: 49783, name: "TEKKEN 8"),
      VideoGame(id: 43868, name: "Street Fighter 6"),
      VideoGame(id: 33945, name: "Guilty Gear: Strive"),
      VideoGame(id: 15, name: "Brawlhalla"),
      VideoGame(id: 48548, name: "Granblue Fantasy Versus: Rising"),
      VideoGame(id: 40849, name: "MultiVersus"),
      VideoGame(id: 48599, name: "Mortal Kombat 1")
    ]
  }
  
  private static func convertIDsToVideoGames(ids: Set<Int>) -> [VideoGame] {
    var games = [VideoGame]()
    let recommendedGames = getRecommendedGames()
    for game in recommendedGames {
      if ids.contains(game.id) {
        games.append(game)
      }
    }
    return games
  }
}
