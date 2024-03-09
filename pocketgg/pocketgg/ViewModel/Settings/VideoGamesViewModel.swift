import SwiftUI
import CoreData

enum VideoGamesViewState {
  case uninitialized
  case loading
  case loaded([VideoGameEntity])
  case error
}

final class VideoGamesViewModel: ObservableObject {
  @Published var state: VideoGamesViewState
  
  private let coreDataService: CoreDataService
  private var enabledVideoGames: [VideoGameEntity]
  private let userDefaults: UserDefaults
  
  private var sentVideoGamesChangedNotification: Bool
  
  init(
    coreDataService: CoreDataService = .shared,
    userDefaults: UserDefaults = .standard
  ) {
    self.state = .uninitialized
    self.coreDataService = coreDataService
    self.enabledVideoGames = []
    self.userDefaults = userDefaults
    self.sentVideoGamesChangedNotification = false
  }
  
  func resetVideoGamesChangedNotification() {
    sentVideoGamesChangedNotification = false
  }
  
  // MARK: Get Saved Video Games
  
  @MainActor
  func getSavedVideoGames() {
    // Don't check for uninitialized state; this method should be called every time VideoGamesView appears (via .task)
    // to account for any changes from VideoGameSearchView
    do {
      enabledVideoGames = try VideoGamePreferenceService.getVideoGames()
      state = .loaded(enabledVideoGames)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Delete Saved Video Game
  
  func deleteVideoGame(at offsets: IndexSet) {
    let index = offsets[offsets.startIndex]
    let videoGameEntity = enabledVideoGames.remove(at: index)
    let id = Int(videoGameEntity.id)
    coreDataService.context.delete(videoGameEntity)
    // Save the change in Core Data
    coreDataService.save()
    // Refresh the VideoGamesViewState to update the change in VideoGamesView
    state = .loaded(enabledVideoGames)
    
    updateHomeViewSections(id: id)
    
    if !sentVideoGamesChangedNotification {
      NotificationCenter.default.post(name: Notification.Name(Constants.videoGamesChanged), object: nil)
      sentVideoGamesChangedNotification = true
    }
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
