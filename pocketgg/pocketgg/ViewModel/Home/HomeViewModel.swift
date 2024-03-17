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
    
    // TODO: Batch network calls:
    // each pinned tournament (by id)
    // featured tournaments
    // upcoming tournaments
    // each enabled video game
    
    async let featuredTournaments = homeViewLayout.contains(-2)
      ? TournamentsGroup(name: "Featured", tournaments: service.getFeaturedTournaments(pageNum: 1, gameIDs: [1]))
      : nil
    async let upcomingTournaments = homeViewLayout.contains(-3)
      ? TournamentsGroup(name: "Upcoming", tournaments: service.getUpcomingTournaments(pageNum: 1, gameIDs: [1]))
      : nil
    
    do {
      let tournamentGroups = try await [featuredTournaments, upcomingTournaments]
      let sortedTournamentGroups = homeViewLayout.compactMap {
        switch $0 {
        case -2:
          return tournamentGroups[safe: 0] ?? nil
        case -3:
          return tournamentGroups[safe: 1] ?? nil
        default:
          return nil
        }
      }
      
      state = .loaded(sortedTournamentGroups)
    } catch {
      state = .error
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
