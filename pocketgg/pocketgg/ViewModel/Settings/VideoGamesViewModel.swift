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
  
  private var coreDataService: CoreDataService
  private var enabledVideoGames: [VideoGameEntity]
  
  init(coreDataService: CoreDataService = .shared) {
    self.state = .uninitialized
    self.coreDataService = coreDataService
    self.enabledVideoGames = []
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
    coreDataService.context.delete(videoGameEntity)
    // Save the change in Core Data
    coreDataService.save()
    // Refresh the VideoGamesViewState to update the change in VideoGamesView
    state = .loaded(enabledVideoGames)
  }
}
