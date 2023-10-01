import Foundation

private enum Constants {
  static let accessTokenLastRefreshed = "accessTokenLastRefreshed"
}

final class LoginViewModel: ObservableObject {
  
  private let oAuthService: OAuthService
  
  init(oAuthService: OAuthService) {
    self.oAuthService = oAuthService
  }
  
  func logIn() async {
    Task {
      do {
        let accessToken = try await oAuthService.webAuthAsync()
        
      } catch {
        // TODO: Present error
        print(error)
      }
    }
  }
  
  func saveTokens(_ response: AccessTokenResponse, _ complete: @escaping (Result<Void, Error>) -> Void) {
    // By default, tokens expire in 604800 seconds (7 days)
    // Try to get a new access token once every day
    UserDefaults.standard.set(Date(), forKey: Constants.accessTokenLastRefreshed)

    do {
      try KeychainService.upsertToken(response.accessToken, .accessToken)
      try KeychainService.upsertToken(response.refreshToken, .refreshToken)
    } catch {
      complete(.failure(error))
      return
    }

    Network.shared.updateApolloClient()
    complete(.success(()))
  }
}
