import Foundation

enum RootView {
  case login
  case home
}

final class AppRootManager: ObservableObject {
  
  @Published var currentRoot: RootView
  
  init() {
    do {
      guard try KeychainService.getToken(.accessToken) != "" else {
        currentRoot = .login
        return
      }
      currentRoot = .home
    } catch {
      currentRoot = .login
    }
  }
}
