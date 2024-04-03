import Foundation

final class PinnedTournamentService {
  static func tournamentIsPinned(
    tournamentID: Int,
    userDefaults: UserDefaults = .standard
  ) -> Bool {
    let pinnedTournamentIDs = userDefaults.array(forKey: Constants.pinnedTournamentIDs) as? [Int] ?? []
    return pinnedTournamentIDs.contains(tournamentID)
  }
  
  static func toggleTournamentPinStatus(
    tournamentID: Int,
    userDefaults: UserDefaults = .standard
  ) {
    var pinnedTournamentIDs = userDefaults.array(forKey: Constants.pinnedTournamentIDs) as? [Int] ?? []
    if let index = pinnedTournamentIDs.firstIndex(of: tournamentID) {
      pinnedTournamentIDs.remove(at: index)
    } else {
      pinnedTournamentIDs.append(tournamentID)
    }
    userDefaults.set(pinnedTournamentIDs, forKey: Constants.pinnedTournamentIDs)
  }
  
  static func savePinnedTournaments(
    _ tournaments: [Tournament],
    userDefaults: UserDefaults = .standard
  ) {
    let tournamentIDs = tournaments.map { $0.id }
    userDefaults.set(tournamentIDs, forKey: Constants.pinnedTournamentIDs)
  }
}
