import SwiftUI

final class TournamentHeaderViewModel: ObservableObject {
  @Published var location: String?
  
  var id: Int
  var name: String
  var imageURL: String
  var date: String
  
  init(id: Int, name: String, imageURL: String, date: String) {
    self.id = id
    self.name = name
    self.imageURL = imageURL
    self.date = date
    
    Task {
      await setTournamentLocation()
    }
  }
  
  @MainActor
  private func setTournamentLocation() async {
    location = await getTournamentLocation()
  }
  
  private nonisolated func getTournamentLocation() async -> String? {
    do {
      if let location = try await Network.shared.getTournamentLocation(id: id) {
        return location
      }
    } catch {
      print(error) // TODO: Handle error
    }
    return nil
  }
}
