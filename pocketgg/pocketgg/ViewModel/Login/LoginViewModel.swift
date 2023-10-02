import SwiftUI

final class LoginViewModel: ObservableObject {
  
  @Published var loggedInSuccessfully = false
  @Published var showingAlert = false
  @Published var alertMessage = ""
  
  private let oAuthService: OAuthService
  
  init(oAuthService: OAuthService) {
    self.oAuthService = oAuthService
  }
  
  // MARK: Log In
  
  func logIn() async {
    do {
      let tokenResponse = try await oAuthService.webAuthAsync()
      try await oAuthService.saveTokens(tokenResponse)
      await MainActor.run {
        loggedInSuccessfully = true
      }
    } catch {
      alertMessage = error.localizedDescription
      showingAlert = true
    }
  }
}
