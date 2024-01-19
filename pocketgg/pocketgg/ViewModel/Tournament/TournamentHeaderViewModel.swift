import SwiftUI

final class TournamentHeaderViewModel: ObservableObject {
  @Published var location: String?
  
  private let id: Int
  private let service: StartggServiceType
  
  init(id: Int, service: StartggServiceType = StartggService.shared) {
    self.id = id
    self.service = service
    
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
      if let location = try await service.getTournamentLocation(id: id) {
        return location
      }
    } catch {
      print(error) // TODO: Handle error
    }
    return nil
  }
}
