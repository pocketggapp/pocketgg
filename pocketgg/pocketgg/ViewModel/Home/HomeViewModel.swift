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
          // TODO: Each pinned tournament
          taskGroup.addTask {
            switch sectionID {
            case -2:
              return try await TournamentsGroup(
                id: sectionID,
                name: "Featured",
                tournaments: self.service.getFeaturedTournaments(pageNum: 1, gameIDs: [1]) // TODO: Make this call load only 10
              )
            case -3:
              return try await TournamentsGroup(
                id: sectionID,
                name: "Upcoming",
                tournaments: self.service.getUpcomingTournaments(pageNum: 1, gameIDs: [1])
              )
            default:
              return try await TournamentsGroup(
                id: sectionID,
                name: videoGames.first(where: { $0.id == sectionID })?.name ?? "",
                tournaments: self.service.getTournaments(pageNum: 1, perPage: 10, gameIDs: [sectionID])
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
      // TODO: Figure out why this is failing on the first load
      #if DEBUG
      print("HomeViewModel: \(error)")
      #endif
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
