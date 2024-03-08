import SwiftUI
import StartggAPI

enum HomeViewState {
  case uninitialized
  case loading
  case loaded([TournamentsGroup])
  case error(String)
}

final class HomeViewModel: ObservableObject {
  @Published var state: HomeViewState
  @Published var showingOnboardingView: Bool
  
  private let service: StartggServiceType
  private let userDefaults: UserDefaults
  
  var videoGamesChanged = false
  
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
        if videoGamesChanged {
          videoGamesChanged = false
          break
        } else {
          return
        }
      }
    }
    
    let videoGame = getSavedVideoGames()
    // TODO: Also get order of home screen sections, and map those to tournamnetggroups
    
    state = .loading
    do {
      let tournaments = try await service.getFeaturedTournaments(pageNum: 1, gameIDs: [1])
      state = .loaded([TournamentsGroup(name: "Featured", tournaments: tournaments)])
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  // MARK: Get Saved Video Games
  
  private func getSavedVideoGames() -> [VideoGame] {
    // Don't check for uninitialized state; this method should be called every time HomeView appears (via .task)
    // to account for any changes
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
