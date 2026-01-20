import SwiftUI

enum TournamentSearchViewState {
  case uninitialized
  case loading
  case loaded([Tournament])
  case error(is503: Bool)
}

final class TournamentSearchViewModel: ObservableObject {
  @Published var state: TournamentSearchViewState
  @Published var searchText = ""
  
  private let service: StartggServiceType
  private let numTournamentsToLoad: Int
  private var accumulatedTournaments: [Tournament]
  private var currentTournamentsPage: Int
  var noMoreTournaments: Bool
  
  init(service: StartggServiceType = StartggService.shared) {
    self.state = .uninitialized
    self.service = service
    self.numTournamentsToLoad = max(20, 2 * Int(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 100))
    self.accumulatedTournaments = []
    self.currentTournamentsPage = 1
    self.noMoreTournaments = false
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments(newSearch: Bool = false, getNextPage: Bool = false) async {
    if newSearch {
      state = .loading
      accumulatedTournaments.removeAll(keepingCapacity: true)
      currentTournamentsPage = 1
      noMoreTournaments = false
    }
    if getNextPage {
      currentTournamentsPage += 1
    }
    if noMoreTournaments { return }
    
    do {
      let tournaments = try await service.getTournamentsBySearchTerm(
        name: searchText,
        pageNum: currentTournamentsPage,
        perPage: numTournamentsToLoad
      )
      
      if !tournaments.isEmpty {
        accumulatedTournaments.append(contentsOf: tournaments)
      }
      if tournaments.count < numTournamentsToLoad {
        noMoreTournaments = true
      }
      state = .loaded(accumulatedTournaments)
    } catch {
      state = .error(is503: error.is503Error)
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  // MARK: Text Field
  
  func onKeyPressed() {
    switch state {
    case .uninitialized, .loading:
      return
    case .loaded, .error:
      if accumulatedTournaments.isEmpty {
        Task { @MainActor in
          state = .uninitialized
        }
      }
    }
  }
}
