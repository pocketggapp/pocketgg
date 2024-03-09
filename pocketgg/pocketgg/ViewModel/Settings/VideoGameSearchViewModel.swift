import SwiftUI
import CoreData

enum VideoGameSearchViewState {
  case uninitialized
  case loading
  case loaded([VideoGame])
  case error
}

final class VideoGameSearchViewModel: ObservableObject {
  @Published var state: VideoGameSearchViewState
  @Published var searchText = ""
  
  private let coreDataService: CoreDataService
  private var enabledVideoGames: [VideoGameEntity]
  private let userDefaults: UserDefaults
  
  private let service: StartggServiceType
  private var accumulatedVideoGames: [VideoGame]
  /// Ensures no duplicate video games are returned by the start.gg videogames query, which happens when the last page has less than 50 results
  private var accumulatedVideoGameIDs: Set<Int>
  private var currentVideoGamesPage: Int
  var noMoreVideoGames: Bool
  
  private var sentVideoGamesChangedNotification: Bool
  
  init(
    service: StartggServiceType = StartggService.shared,
    coreDataService: CoreDataService = .shared,
    userDefaults: UserDefaults = .standard
  ) {
    self.state = .uninitialized
    self.coreDataService = coreDataService
    self.enabledVideoGames = []
    self.userDefaults = userDefaults
    self.service = service
    self.accumulatedVideoGames = []
    self.accumulatedVideoGameIDs = []
    self.currentVideoGamesPage = 1
    self.noMoreVideoGames = false
    self.sentVideoGamesChangedNotification = false
  }
  
  func resetVideoGamesChangedNotification() {
    sentVideoGamesChangedNotification = false
  }
  
  // MARK: Fetch Video Games
  
  @MainActor
  func fetchVideoGames(newSearch: Bool = false, getNextPage: Bool = false) async {
    if newSearch {
      state = .loading
      accumulatedVideoGames.removeAll(keepingCapacity: true)
      accumulatedVideoGameIDs.removeAll(keepingCapacity: true)
      currentVideoGamesPage = 1
      noMoreVideoGames = false
    }
    if getNextPage {
      currentVideoGamesPage += 1
    }
    if noMoreVideoGames { return }
    
    do {
      let videoGames = try await service.getVideoGames(
        name: searchText,
        page: currentVideoGamesPage,
        accumulatedVideoGameIDs: accumulatedVideoGameIDs
      )
      
      guard let videoGames else {
        state = .loaded(accumulatedVideoGames)
        noMoreVideoGames = true
        return
      }
      
      for videoGame in videoGames {
        accumulatedVideoGameIDs.insert(videoGame.id)
      }
      
      if !videoGames.isEmpty {
        accumulatedVideoGames.append(contentsOf: videoGames)
      }
      if videoGames.count < 50 {
        noMoreVideoGames = true
      }
      state = .loaded(accumulatedVideoGames)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Enabled Video Games
  
  func getEnabledVideoGames(refreshed: Bool = false) {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    do {
      enabledVideoGames = try VideoGamePreferenceService.getVideoGames()
    } catch {
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  func videoGameTapped(_ videoGame: VideoGame) {
    if let index = enabledVideoGames.firstIndex(where: { $0.id == videoGame.id }) {
      // Delete existing video game entity
      let videoGameEntity = enabledVideoGames.remove(at: index)
      coreDataService.context.delete(videoGameEntity)
    } else {
      // Add video game entity
      let videoGameEntity = VideoGameEntity(context: coreDataService.context)
      videoGameEntity.id = Int64(videoGame.id)
      videoGameEntity.name = videoGame.name
    }
    // Save the change in Core Data
    coreDataService.save()
    // Refresh the list of video game entities from Core Data
    getEnabledVideoGames(refreshed: true)
    // Refresh the VideoGameSearchViewState to update the change in VideoGameSearchView
    state = .loaded(accumulatedVideoGames)
    
    updateHomeViewSections(id: videoGame.id)
    
    if !sentVideoGamesChangedNotification {
      NotificationCenter.default.post(name: Notification.Name(Constants.videoGamesChanged), object: nil)
      sentVideoGamesChangedNotification = true
    }
  }
  
  func videoGameEnabled(_ id: Int) -> Bool {
    enabledVideoGames.contains(where: { $0.id == id })
  }
  
  private func updateHomeViewSections(id: Int) {
    var homeViewSections = userDefaults.array(forKey: Constants.homeViewSections) as? [Int] ?? []
    
    if let sectionIndex = homeViewSections.firstIndex(where: { $0 == id }) {
      homeViewSections.remove(at: sectionIndex)
    } else {
      homeViewSections.append(id)
    }
    
    userDefaults.set(homeViewSections, forKey: Constants.homeViewSections)
  }
}
