import SwiftUI

enum TournamentListViewState {
  case uninitialized
  case loaded([Tournament])
  case error
}

final class TournamentListViewModel: ObservableObject {
  @Published var state: TournamentListViewState
  
  private let sectionID: Int
  private var videoGameIDs: [Int]
  
  private let userDefaults: UserDefaults
  private let service: StartggServiceType
  private let numTournamentsToLoad: Int
  private var accumulatedTournaments: [Tournament]
  private var currentTournamentsPage: Int
  var noMoreTournaments: Bool
  
  init(
    sectionID: Int,
    service: StartggServiceType = StartggService.shared,
    userDefaults: UserDefaults = .standard
  ) {
    self.state = .uninitialized
    self.sectionID = sectionID
    self.videoGameIDs = []
    self.userDefaults = userDefaults
    self.service = service
    self.numTournamentsToLoad = max(20, 2 * Int(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 100))
    self.accumulatedTournaments = []
    self.currentTournamentsPage = 1
    self.noMoreTournaments = false
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments(refreshed: Bool = false, getNextPage: Bool = false) async {
    // Ensure the .task modifier in TournamentListView only gets called once
    if !refreshed, !getNextPage {
      switch state {
      case .uninitialized:
        videoGameIDs = getSavedVideoGameIDs()
        break
      default: return
      }
    }
    
    if refreshed {
      accumulatedTournaments.removeAll(keepingCapacity: true)
      currentTournamentsPage = 1
      noMoreTournaments = false
      videoGameIDs = getSavedVideoGameIDs()
    }
    if getNextPage {
      currentTournamentsPage += 1
    }
    if noMoreTournaments { return }
    
    do {
      var tournaments = [Tournament]()
      switch sectionID {
      case -2:
        tournaments = try await service.getFeaturedTournaments(
          pageNum: currentTournamentsPage,
          perPage: numTournamentsToLoad,
          gameIDs: videoGameIDs
        )
      case -3:
        tournaments = try await fetchUpcomingTournaments(gameIDs: videoGameIDs)
      case -4:
        tournaments = try await service.getOnlineTournaments(
          pageNum: currentTournamentsPage,
          perPage: numTournamentsToLoad,
          gameIDs: videoGameIDs
        )
      default:
        tournaments = try await fetchUpcomingTournaments(gameIDs: [sectionID])
      }
      
      if !tournaments.isEmpty {
        accumulatedTournaments.append(contentsOf: tournaments)
      }
      if tournaments.count < numTournamentsToLoad {
        noMoreTournaments = true
      }
      state = .loaded(accumulatedTournaments)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  private func fetchUpcomingTournaments(gameIDs: [Int]) async throws -> [Tournament] {
    if let location = getLocation() {
      return try await service.getUpcomingTournamentsNearLocation(
        pageNum: currentTournamentsPage,
        perPage: numTournamentsToLoad,
        gameIDs: gameIDs,
        coordinates: location.coordinates,
        radius: location.radius
      )
    } else {
      return try await service.getUpcomingTournaments(
        pageNum: currentTournamentsPage,
        perPage: numTournamentsToLoad,
        gameIDs: gameIDs
      )
    }
  }
  
  // MARK: Get Saved Video Games
  
  private func getSavedVideoGameIDs() -> [Int] {
    do {
      let videoGameEntities = try VideoGamePreferenceService.getVideoGames()
      return videoGameEntities.map { Int($0.id) }
    } catch {
      #if DEBUG
      print(error.localizedDescription)
      #endif
      return []
    }
  }
  
  // MARK: Get Location Preference
  
  private func getLocation() -> (coordinates: String, radius: String)? {
    guard userDefaults.bool(forKey: Constants.locationEnabled) else { return nil }
    guard let coordinates = userDefaults.string(forKey: Constants.locationCoordinates), !coordinates.isEmpty else { return nil }
    var radius = userDefaults.string(forKey: Constants.locationDistance) ?? "50"
    if radius.isEmpty { radius = "50" }
    var unit = userDefaults.string(forKey: Constants.locationDistanceUnit) ?? "mi"
    if unit.isEmpty { unit = "mi" }
    return (coordinates, radius + unit)
  }
}
