import SwiftUI

final class EditPinnedTournamentsViewModel: ObservableObject {
  var pinnedTournaments: [Tournament]
  
  private var sentHomeViewRefreshNotification: Bool
  
  init(_ pinnedTournaments: [Tournament]) {
    self.pinnedTournaments = pinnedTournaments
    self.sentHomeViewRefreshNotification = false
  }
  
  // MARK: Edit Pinned Tournaments
  
  func deletePinnedTournament(at offsets: IndexSet) {
    let index = offsets[offsets.startIndex]
    pinnedTournaments.remove(at: index)
    PinnedTournamentService.savePinnedTournaments(pinnedTournaments)
    sendHomeViewRefreshNotification()
  }
  
  func movePinnedTournament(from source: IndexSet, to destination: Int) {
    pinnedTournaments.move(fromOffsets: source, toOffset: destination)
    PinnedTournamentService.savePinnedTournaments(pinnedTournaments)
    sendHomeViewRefreshNotification()
  }
  
  private func sendHomeViewRefreshNotification() {
    guard !sentHomeViewRefreshNotification else { return }
    NotificationCenter.default.post(name: Notification.Name(Constants.refreshHomeView), object: nil)
    sentHomeViewRefreshNotification = true
  }
}
