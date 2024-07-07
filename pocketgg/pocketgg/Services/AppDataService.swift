import Foundation
import CoreData

final class AppDataService {
  /// Initialize app data for new users
  static func newUserOnboarding(
    homeViewSections: [Int],
    userDefaults: UserDefaults = .standard
  ) {
    // Only perform new user onboarding if no previous app version exists
    guard userDefaults.string(forKey: Constants.appVersion) == nil else { return }
    
    // Set the home view sections (pinned, featured, upcoming, online + whatever games the user chose during onboarding)
    userDefaults.set([-1, -2, -3, -4] + homeViewSections, forKey: Constants.homeViewSections)
    
    // Set the current app version
    userDefaults.set(Constants.currentAppVersion, forKey: Constants.appVersion)
  }
  
  /// Migrate app data from app versions 1.2 up until 2.0
  static func appV2Migration(
    coreDataService: CoreDataService = .shared,
    userDefaults: UserDefaults = .standard
  ) {
    // Only perform the v2 migration if a previous app version exists, but it's not 2.0
    guard let lastAppVersion = userDefaults.string(forKey: Constants.appVersion),
          lastAppVersion != Constants.currentAppVersion else {
      return
    }
    
    // Migrate from mainVCSections to homeViewSections
    let mainVCSections = userDefaults.array(forKey: "mainVCSections") as? [Int] ?? [-1, -2, -3, -4]
    userDefaults.set(mainVCSections, forKey: Constants.homeViewSections)
    
    // Migrate saved video games from saved objects to Core Data
    let propertyListDecoder = PropertyListDecoder()
    if let data = userDefaults.data(forKey: "preferredVideoGames") {
      do {
        let videoGames = try propertyListDecoder.decode([VideoGame].self, from: data)
        
        for videoGame in videoGames {
          let videoGameEntity = VideoGameEntity(context: coreDataService.context)
          videoGameEntity.id = Int64(videoGame.id)
          videoGameEntity.name = videoGame.name
          coreDataService.save()
        }
      } catch {
        #if DEBUG
        print(error.localizedDescription)
        #endif
      }
    }
    
    // Migrate saved tournament organizers from saved objects to Core Data
    if let data = userDefaults.data(forKey: "tournamentOrganizersFollowed") {
      do {
        let followedTOs = try propertyListDecoder.decode([TournamentOrganizer].self, from: data)
        
        for tournamentOrganizer in followedTOs {
          let tournamentOrganizerEntity = TournamentOrganizerEntity(context: coreDataService.context)
          tournamentOrganizerEntity.id = Int64(tournamentOrganizer.id)
          tournamentOrganizerEntity.name = tournamentOrganizer.name
          tournamentOrganizerEntity.prefix = tournamentOrganizer.prefix
          tournamentOrganizerEntity.customName = tournamentOrganizer.customName
          tournamentOrganizerEntity.customPrefix = tournamentOrganizer.customPrefix
          coreDataService.save()
        }
        
        let followedTournamentOrganizerIDs = followedTOs.map { $0.id }
        userDefaults.set(followedTournamentOrganizerIDs, forKey: Constants.followedTournamentOrganizerIDs)
      } catch {
        #if DEBUG
        print(error.localizedDescription)
        #endif
      }
    }
    
    // Remove deprecated UserDefaults objects
    userDefaults.removeObject(forKey: "mainVCSections")
    userDefaults.removeObject(forKey: "preferredVideoGames")
    userDefaults.removeObject(forKey: "tournamentOrganizersFollowed")
    userDefaults.removeObject(forKey: "firebaseEnabled")
    
    // Set the current app version
    userDefaults.set(Constants.currentAppVersion, forKey: Constants.appVersion)
  }
}
