import SwiftUI

enum TournamentViewState {
  case uninitialized
  case loading
  case loaded(TournamentDetails?)
  case error
}

final class TournamentViewModel: ObservableObject {
  @Published var state: TournamentViewState
  
  private let tournament: Tournament
  private let service: StartggServiceType
  
  init(
    tournament: Tournament,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.tournament = tournament
    self.service = service
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
      state = .loaded(tournamentDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
