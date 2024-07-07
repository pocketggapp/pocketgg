import SwiftUI
import StartggAPI

enum HomeViewState {
  case uninitialized
  case loading
  case loaded([TournamentsGroup])
  case noSections
  case error
}

final class HomeViewModel: ObservableObject {
  @Published var state: HomeViewState
  @Published var showingOnboardingView: Bool
  
  private let service: StartggServiceType
  private let userDefaults: UserDefaults
  
  /// HomeView needs to be refreshed if a video game was added/removed, the HomeView layout was edited, or a tournament was pinned/unpinned
  var needsRefresh = false
  
  init(
    service: StartggServiceType = StartggService.shared,
    userDefaults: UserDefaults = .standard
  ) {
    self.state = .uninitialized
    self.showingOnboardingView = false
    self.service = service
    self.userDefaults = userDefaults
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments(refreshed: Bool = false) async {
    if !refreshed {
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
    }
    
    state = .loading
    
    let videoGames = getSavedVideoGames()
    let pinnedTournamentIDs = userDefaults.array(forKey: Constants.pinnedTournamentIDs) as? [Int] ?? []
    let homeViewLayout = userDefaults.array(forKey: Constants.homeViewSections) as? [Int] ?? []
    
    guard !homeViewLayout.isEmpty else {
      state = .noSections
      return
    }
    
    do {
      try await withThrowingTaskGroup(of: TournamentsGroup.self) { [weak self] taskGroup in
        guard let self else {
          self?.state = .error
          #if DEBUG
          print("HomeViewModel: self is nil while fetching tournaments")
          #endif
          return
        }
        
        for sectionID in homeViewLayout {
          taskGroup.addTask {
            switch sectionID {
            case -1:
              return try await TournamentsGroup(
                id: -1,
                name: "Pinned",
                tournaments: self.fetchPinnedTournaments(IDs: pinnedTournamentIDs)
              )
            case -2:
              return try await TournamentsGroup(
                id: -2,
                name: "Featured",
                tournaments: self.service.getFeaturedTournaments(pageNum: 1, perPage: 10, gameIDs: videoGames.map { $0.id })
              )
            case -3:
              return try await TournamentsGroup(
                id: -3,
                name: "Upcoming",
                tournaments: self.fetchUpcomingTournaments(gameIDs: videoGames.map { $0.id })
              )
            case -4:
              return try await TournamentsGroup(
                id: -4,
                name: "Online",
                tournaments: self.service.getOnlineTournaments(pageNum: 1, perPage: 10, gameIDs: videoGames.map { $0.id })
              )
            default:
              return try await TournamentsGroup(
                id: sectionID,
                name: videoGames.first(where: { $0.id == sectionID })?.name ?? "",
                tournaments: self.fetchUpcomingTournaments(gameIDs: [sectionID])
              )
            }
          }
        }
        
        var tournamentGroups = [TournamentsGroup]()
        while let tournamentsGroup = try await taskGroup.next() {
          tournamentGroups.append(tournamentsGroup)
        }
        
        let sortedTournamentGroups = homeViewLayout.compactMap { sectionID in
          tournamentGroups.first(where: { $0.id == sectionID })
        }
        
        state = .loaded(sortedTournamentGroups)
      }
    } catch {
      state = .error
      #if DEBUG
      print("HomeViewModel: \(error)")
      #endif
    }
  }
  
  private func fetchPinnedTournaments(IDs: [Int]) async throws -> [Tournament] {
    try await withThrowingTaskGroup(of: Tournament?.self) { [weak self] taskGroup in
      guard let self else {
        #if DEBUG
        print("HomeViewModel: self is nil while fetching pinned tournaments")
        #endif
        return []
      }
      
      for id in IDs {
        taskGroup.addTask {
          return try await self.service.getTournament(id: id)
        }
      }
      
      var tournaments = [Tournament?]()
      while let tournament = try await taskGroup.next() {
        tournaments.append(tournament)
      }
      
      return IDs.compactMap { id in
        tournaments.first(where: { $0?.id == id }) ?? nil
      }
    }
  }
  
  private func fetchUpcomingTournaments(gameIDs: [Int]) async throws -> [Tournament] {
    if let location = getLocation() {
      return try await service.getUpcomingTournamentsNearLocation(
        pageNum: 1,
        perPage: 10,
        gameIDs: gameIDs,
        coordinates: location.coordinates,
        radius: location.radius
      )
    } else {
      return try await service.getUpcomingTournaments(
        pageNum: 1,
        perPage: 10,
        gameIDs: gameIDs
      )
    }
  }
  
  // MARK: Get Saved Video Games
  
  private func getSavedVideoGames() -> [VideoGame] {
    do {
      let videoGameEntities = try VideoGamePreferenceService.getVideoGames()
      return videoGameEntities.compactMap { entity -> VideoGame? in
        guard let name = entity.name else { return nil }
        return VideoGame(id: Int(entity.id), name: name)
      }
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
  
  // MARK: Onboarding View
  
  func presentOnboardingViewIfNeeded() {
    switch state {
    case .uninitialized: break
    default: return
    }
    
    if userDefaults.string(forKey: Constants.appVersion) != Constants.currentAppVersion {
      showingOnboardingView = true
    }
  }
  
  func getOnboardingFlowType() -> OnboardingFlowType? {
    guard let mostRecentAppVersion = userDefaults.string(forKey: Constants.appVersion) else { return .newUser }
    return mostRecentAppVersion == Constants.currentAppVersion ? nil : .appUpdate
  }
}
