import SwiftUI

enum TournamentViewState {
  case uninitialized
  case loading
  case loaded(TournamentDetails?)
  case error(String)
}

final class TournamentViewModel: ObservableObject {
  @Published var state: TournamentViewState
  
  private let tournamentData: TournamentData
  private let service: StartggServiceType
  
  init(tournamentData: TournamentData, service: StartggServiceType = StartggService.shared) {
    self.state = .uninitialized
    self.tournamentData = tournamentData
    self.service = service
  }
  
  func onViewAppear() {
    Task {
      switch state {
      case .uninitialized:
        await fetchTournament()
      default: return
      }
    }
  }
  
  // MARK: Fetch Tournament
  
  @MainActor
  private func fetchTournament() async {
    state = .loading
    do {
      let tournamentDetails = try await service.getTournamentDetails(id: tournamentData.id)
      state = .loaded(tournamentDetails)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
}
