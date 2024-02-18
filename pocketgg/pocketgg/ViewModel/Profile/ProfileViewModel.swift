import SwiftUI

enum ProfileViewState {
  case uninitialized
  case loading
  case loaded(Profile?)
  case error
}

final class ProfileViewModel: ObservableObject {
  @Published var state: ProfileViewState
  
  private let service: StartggServiceType
  
  init(
    service: StartggServiceType = StartggService.shared
  ) {
    self.state = .uninitialized
    self.service = service
  }
  
  // MARK: Fetch Profile
  
  @MainActor
  func fetchProfile(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    state = .loading
    do {
      let profile = try await service.getCurrentUserProfile()
      state = .loaded(profile)
    } catch {
      state = .error
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
}
