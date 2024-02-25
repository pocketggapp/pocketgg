import SwiftUI

enum VideoGameSearchViewState {
  case uninitialized
  case loading
  case loaded([VideoGame])
  case error
}

final class VideoGameSearchViewModel: ObservableObject {
  @Published var state: VideoGameSearchViewState
  @Published var searchText = ""
  @Published var enabledVideoGameIDs: Set<Int>
  
  private let service: StartggServiceType
  private var accumulatedVideoGames: [VideoGame]
  private var currentVideoGamesPage: Int
  var noMoreVideoGames: Bool
  
  init(
    enabledVideoGameIDs: Set<Int>,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.enabledVideoGameIDs = enabledVideoGameIDs
    self.service = service
    self.accumulatedVideoGames = []
    self.currentVideoGamesPage = 1
    self.noMoreVideoGames = false
  }
  
  // MARK: Fetch Video Games
  
  @MainActor
  func fetchVideoGames(newSearch: Bool = false, getNextPage: Bool = false) async {
    if newSearch {
      state = .loading
      accumulatedVideoGames.removeAll(keepingCapacity: true)
      currentVideoGamesPage = 1
      noMoreVideoGames = false
    }
    if getNextPage {
      currentVideoGamesPage += 1
    }
    if noMoreVideoGames { return }
    
    do {
      let videoGames = try await service.getVideoGames(name: searchText, page: currentVideoGamesPage)
      guard let videoGames else {
        state = .loaded(accumulatedVideoGames)
        noMoreVideoGames = true
        return
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
  
  func videoGameTapped(id: Int) {
    if enabledVideoGameIDs.contains(id) {
      enabledVideoGameIDs.remove(id)
    } else {
      enabledVideoGameIDs.insert(id)
    }
  }
  
  func setContainsID(_ id: Int) -> Bool {
    enabledVideoGameIDs.contains(id)
  }
}
