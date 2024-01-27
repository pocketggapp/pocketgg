import SwiftUI

enum TournamentViewState {
  case uninitialized
  case loading
  case loaded(TournamentDetails?)
  case error
}

final class TournamentViewModel: ObservableObject {
  @Published var state: TournamentViewState
  
  private let tournamentData: TournamentData
  private let service: StartggServiceType
  
  init(
    tournamentData: TournamentData,
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.tournamentData = tournamentData
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
      let tournamentDetails = try await service.getTournamentDetails(id: tournamentData.id)
      state = .loaded(tournamentDetails)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
