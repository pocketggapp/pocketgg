import Foundation

enum RootView {
  case startup
  case login
  case home
}

final class AppRootManager: ObservableObject {
  @Published var currentRoot: RootView
  
  init() {
    currentRoot = .startup
  }
}
