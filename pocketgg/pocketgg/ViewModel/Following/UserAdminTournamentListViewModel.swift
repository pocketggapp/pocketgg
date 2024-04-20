import SwiftUI

enum UserAdminTournamentListViewState {
  case uninitialized
  case loaded([Tournament])
  case error
}

final class UserAdminTournamentListViewModel: ObservableObject {
  @Published var state: UserAdminTournamentListViewState
  @Published var isFollowed: Bool
  
  private let user: Entrant
  
  private let service: StartggServiceType
  private let numTournamentsToLoad: Int
  private var accumulatedTournaments: [Tournament]
  private var currentTournamentsPage: Int
  var noMoreTournaments: Bool
  
  private var sentFollowingViewRefreshNotification: Bool
  
  init(
    user: Entrant,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.user = user
    self.service = service
    self.numTournamentsToLoad = max(20, 2 * Int(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 100))
    self.accumulatedTournaments = []
    self.currentTournamentsPage = 1
    self.noMoreTournaments = false
    self.sentFollowingViewRefreshNotification = false
    
    do {
      self.isFollowed = try FollowedTOsService.tournamentOrganizerIsFollowed(id: user.id)
    } catch {
      #if DEBUG
      print("UserAdminTournamentListViewModel: Error getting tournament organizers from Core Data")
      #endif
      self.isFollowed = false
    }
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
        userID: user.id,
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
  
  func toggleTournamentOrganizerFollowedStatus() {
    do {
      self.isFollowed = try FollowedTOsService.toggleTournamentOrganizerFollowedStatus(tournamentOrganizer: user)
      if !sentFollowingViewRefreshNotification {
        NotificationCenter.default.post(name: Notification.Name(Constants.refreshFollowingView), object: nil)
        sentFollowingViewRefreshNotification = true
      }
    } catch {
      #if DEBUG
      print("UserAdminTournamentListViewModel: Error getting tournament organizers from Core Data")
      #endif
      self.isFollowed = false
    }
  }
  
  func resetFollowingViewRefreshNotification() {
    sentFollowingViewRefreshNotification = false
  }
}
