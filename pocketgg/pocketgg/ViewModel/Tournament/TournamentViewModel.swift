import SwiftUI

enum TournamentViewState {
  case uninitialized
  case loading
  case loaded(TournamentDetails?)
  case error(String)
}

final class TournamentViewModel: ObservableObject {
  @Published var state: TournamentViewState
  
  let tournamentData: TournamentData
  
  init(tournamentData: TournamentData) {
    self.tournamentData = tournamentData
    self.state = .uninitialized
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
      let tournamentDetails = try await Network.shared.getTournamentDetails(id: tournamentData.id)
      state = .loaded(tournamentDetails)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
}
