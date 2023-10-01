import SwiftUI

private enum Constants {
  static let accessTokenLastRefreshed = "accessTokenLastRefreshed"
}

final class LoginViewModel: ObservableObject {
  
  private let oAuthService: OAuthService
  @Published var loggedInSuccessfully = false
  
  init(oAuthService: OAuthService) {
    self.oAuthService = oAuthService
  }
  
  func logIn() async {
      do {
        let tokenResponse = try await oAuthService.webAuthAsync()
        try await saveTokens(tokenResponse)
        await MainActor.run {
          loggedInSuccessfully = true
        }
      } catch {
        // TODO: Present error
        print(error)
      }
  }
  
  func saveTokens(_ response: AccessTokenResponse) async throws {
    // By default, tokens expire in 604800 seconds (7 days)
    // Try to get a new access token once every day
    UserDefaults.standard.set(Date(), forKey: Constants.accessTokenLastRefreshed)
    
    return try await withCheckedThrowingContinuation { continuation in
      do {
        try KeychainService.upsertToken(response.accessToken, .accessToken)
        try KeychainService.upsertToken(response.refreshToken, .refreshToken)
      } catch {
        continuation.resume(throwing: error)
        return
      }

      Network.shared.updateApolloClient()
      continuation.resume()
    }
  }
}
