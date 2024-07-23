import SwiftUI

enum UserAdminTournamentListViewState {
  case uninitialized
  case loaded([Tournament])
  case error
}

final class UserAdminTournamentListViewModel: ObservableObject {
  @Published var state: UserAdminTournamentListViewState
  @Published var isFollowed: Bool
  
  @Published var customName: String
  @Published var customPrefix: String
  @Published var navigationTitle: String
  
  private let coreDataService: CoreDataService
  private var oldName: String /// The name of the tournament organizer before the start of the rename, so any changes can be reverted if the rename is cancelled
  private var oldPrefix: String /// The prefix of the tournament organizer before the start of the rename, so any changes can be reverted if the rename is cancelled
  
  private let user: Entrant
  
  private let service: StartggServiceType
  private let numTournamentsToLoad: Int
  private var accumulatedTournaments: [Tournament]
  private var currentTournamentsPage: Int
  var noMoreTournaments: Bool
  
  private var sentFollowingViewRefreshNotification: Bool
  
  init(
    user: Entrant,
    service: StartggServiceType = StartggService.shared,
    coreDataService: CoreDataService = .shared
  ) {
    self.state = .uninitialized
    self.user = user
    self.service = service
    self.coreDataService = coreDataService
    self.numTournamentsToLoad = max(20, 2 * Int(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 100))
    self.accumulatedTournaments = []
    self.currentTournamentsPage = 1
    self.noMoreTournaments = false
    self.sentFollowingViewRefreshNotification = false
    
    do {
      self.isFollowed = try FollowedTOsService.tournamentOrganizerIsFollowed(id: user.id)
      
      let tournamentOrganizerEntities = try FollowedTOsService.getTournamentOrganizers()
      if let entity = tournamentOrganizerEntities.first(where: { $0.id == user.id }) {
        self.customName = entity.customName ?? ""
        self.customPrefix = entity.customPrefix ?? ""
        self.oldName = entity.customName ?? ""
        self.oldPrefix = entity.customPrefix ?? ""
        if let customName = entity.customName, let customPrefix = entity.customPrefix, !customName.isEmpty, !customPrefix.isEmpty {
          self.navigationTitle = "\(customPrefix) \(customName)"
        } else if let customName = entity.customName, !customName.isEmpty {
          self.navigationTitle = customName
        } else if let customPrefix = entity.customPrefix, !customPrefix.isEmpty {
          self.navigationTitle = customPrefix
        } else {
          let formattedName = user.formattedName()
          self.navigationTitle = "\(formattedName.prefix) \(formattedName.name)"
        }
      } else {
        self.customName = ""
        self.customPrefix = ""
        self.oldName = user.name ?? ""
        self.oldPrefix = user.teamName ?? ""
        let formattedName = user.formattedName()
        self.navigationTitle = "\(formattedName.prefix) \(formattedName.name)"
      }
    } catch {
      #if DEBUG
      print("UserAdminTournamentListViewModel: Error getting tournament organizers from Core Data")
      #endif
      self.isFollowed = false
      self.customName = ""
      self.customPrefix = ""
      self.oldName = user.name ?? ""
      self.oldPrefix = user.teamName ?? ""
      let formattedName = user.formattedName()
      self.navigationTitle = "\(formattedName.prefix) \(formattedName.name)"
    }
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments(refreshed: Bool = false, getNextPage: Bool = false, role: String) async {
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
      var tournaments = [Tournament]()
      switch role {
      case "Organizer":
        tournaments = try await fetchUserOrganizingTournaments()
      case "Admin":
        tournaments = try await fetchUserAdminTournaments()
      case "Competitor":
        tournaments = try await fetchUserCompetingTournaments()
      default:
        break
      }
      
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
  
  private func fetchUserOrganizingTournaments() async throws -> [Tournament] {
    return try await service.getUserOrganizingTournaments(
      userID: user.id,
      pageNum: currentTournamentsPage,
      perPage: numTournamentsToLoad
    )
  }
  
  private func fetchUserAdminTournaments() async throws -> [Tournament] {
    return try await service.getUserAdminTournaments(
      userID: user.id,
      pageNum: currentTournamentsPage,
      perPage: numTournamentsToLoad
    )
  }
  
  private func fetchUserCompetingTournaments() async throws -> [Tournament] {
    return try await service.getUserCompetingTournaments(
      userID: user.id,
      pageNum: currentTournamentsPage,
      perPage: numTournamentsToLoad
    )
  }
  
  // MARK: Toggle Followed Status
  
  func toggleTournamentOrganizerFollowedStatus() {
    do {
      self.isFollowed = try FollowedTOsService.toggleTournamentOrganizerFollowedStatus(tournamentOrganizer: user)
      sendFollowingViewRefreshNotification()
    } catch {
      #if DEBUG
      print("UserAdminTournamentListViewModel: Error getting tournament organizers from Core Data")
      #endif
      self.isFollowed = false
    }
  }
  
  // MARK: Rename
  
  func renameTournamentOrganizer() {
    do {
      try FollowedTOsService.renameTournamentOrganizer(
        id: user.id,
        customName: customName,
        customPrefix: customPrefix
      )
      navigationTitle = getNavigationTitle()
      sendFollowingViewRefreshNotification()
      
      oldName = customName
      oldPrefix = customPrefix
    } catch {
      #if DEBUG
      print("UserAdminTournamentListViewModel: Rename TO failed")
      #endif
    }
  }
  
  func cancelTournamentOrganizerRename() {
    customName = oldName
    customPrefix = oldPrefix
    navigationTitle = getNavigationTitle()
  }
  
  func getNavigationTitle() -> String {
    if !customName.isEmpty, !customPrefix.isEmpty {
      return "\(customPrefix) \(customName)"
    } else if !customName.isEmpty {
      return customName
    } else if !customPrefix.isEmpty {
      return customPrefix
    } else {
      let formattedName = user.formattedName()
      return "\(formattedName.prefix) \(formattedName.name)"
    }
  }
  
  func resetFollowingViewRefreshNotification() {
    sentFollowingViewRefreshNotification = false
  }
  
  private func sendFollowingViewRefreshNotification() {
    guard !sentFollowingViewRefreshNotification else { return }
    NotificationCenter.default.post(name: Notification.Name(Constants.refreshFollowingView), object: nil)
    sentFollowingViewRefreshNotification = true
  }
}
