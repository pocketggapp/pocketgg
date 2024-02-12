import SwiftUI

final class LoginViewModel: ObservableObject {
  @Published var loggedInSuccessfully = false
  @Published var showingAlert = false
  @Published var alertMessage = ""
  
  private let oAuthService: OAuthServiceType
  
  init(oAuthService: OAuthServiceType = OAuthService.shared) {
    self.oAuthService = oAuthService
  }
  
  // MARK: Log In
  
  @MainActor
  func logIn() async {
    do {
      let tokenResponse = try await oAuthService.webAuthAsync()
      try await oAuthService.saveTokens(tokenResponse)
      loggedInSuccessfully = true
    } catch {
      alertMessage = error.localizedDescription
      showingAlert = true
    }
  }
}
