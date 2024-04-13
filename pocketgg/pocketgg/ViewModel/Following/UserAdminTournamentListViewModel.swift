import SwiftUI

enum UserAdminTournamentListViewState {
  case uninitialized
  case loaded([Tournament])
  case error
}

final class UserAdminTournamentListViewModel: ObservableObject {
  @Published var state: UserAdminTournamentListViewState
  
  private let userID: Int
  
  private let service: StartggServiceType
  private let numTournamentsToLoad: Int
  private var accumulatedTournaments: [Tournament]
  private var currentTournamentsPage: Int
  var noMoreTournaments: Bool
  
  init(
    userID: Int,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.userID = userID
    self.service = service
    self.numTournamentsToLoad = max(20, 2 * Int(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 100))
    self.accumulatedTournaments = []
    self.currentTournamentsPage = 1
    self.noMoreTournaments = false
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments(refreshed: Bool = false, getNextPage: Bool = false) async {
    // Ensure the .task modifier in UserAdminTournamentListView only gets called once
    if !refreshed, !getNextPage {
      switch state {
      case .uninitialized:
        break
      default: return
      }
    }
    
    if refreshed {
      accumulatedTournaments.removeAll(keepingCapacity: true)
      currentTournamentsPage = 1
      noMoreTournaments = false
    }
    if getNextPage {
      currentTournamentsPage += 1
    }
    if noMoreTournaments { return }
    
    do {
      let tournaments = try await service.getUserAdminTournaments(
        userID: userID,
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
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
