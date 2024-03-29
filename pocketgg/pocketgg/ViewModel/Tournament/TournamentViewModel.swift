import SwiftUI

enum TournamentViewState {
  case uninitialized
  case loading
  case loaded(TournamentDetails?)
  case error
}

final class TournamentViewModel: ObservableObject {
  @Published var state: TournamentViewState
  @Published var isPinned: Bool
  @Published var tournamentURL: URL?
  
  private let tournament: Tournament
  private let service: StartggServiceType
  
  private var sentHomeViewRefreshNotification: Bool
  
  init(
    tournament: Tournament,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.isPinned = PinnedTournamentService.tournamentIsPinned(tournamentID: tournament.id)
    self.tournament = tournament
    self.service = service
    self.sentHomeViewRefreshNotification = false
  }
  
  // MARK: Fetch Tournament
  
  @MainActor
  func fetchTournament(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let tournamentDetails = try await service.getTournamentDetails(id: tournament.id)
      getTournamentURL(slug: tournamentDetails?.slug)
      state = .loaded(tournamentDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  func toggleTournamentPinStatus() {
    PinnedTournamentService.toggleTournamentPinStatus(tournamentID: tournament.id)
    isPinned.toggle()
    if !sentHomeViewRefreshNotification {
      NotificationCenter.default.post(name: Notification.Name(Constants.refreshHomeView), object: nil)
      sentHomeViewRefreshNotification = true
    }
  }
  
  func resetHomeViewRefreshNotification() {
    sentHomeViewRefreshNotification = false
  }
  
  private func getTournamentURL(slug: String?) {
    guard let slug, let url = URL(string: "https://www.start.gg/\(slug)/details") else { return }
    tournamentURL = url
  }
}
