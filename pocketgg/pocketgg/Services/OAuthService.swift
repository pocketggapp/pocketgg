import Foundation
import AuthenticationServices

private enum OAuthConstants {
  static let accessTokenEndpoint = "https://api.start.gg/oauth/access_token"
  static let refreshTokenEndpoint = "https://api.start.gg/oauth/refresh"
  static let redirectURI = "https://pocketggapp.github.io/oauth_callback"
  static let clientID = "17"
}

enum LoginError: Error {
  case noCallbackURL
  case noAuthCode
  case selfNil
  case serverUnavailable
}

enum OAuthError: Error {
  case dataTaskError(String)
  case invalidData
  case invalidClientSecret
}

struct AccessTokenResponse: Codable {
  let accessToken: String
  let tokenType: String
  let expiresIn: Int
  let refreshToken: String
}

protocol OAuthServiceType {
  func webAuthAsync() async throws -> AccessTokenResponse
  func refreshAccessToken() async throws -> AccessTokenResponse
  func saveTokens(_ response: AccessTokenResponse) async throws
}

final class OAuthService: NSObject, ASWebAuthenticationPresentationContextProviding, OAuthServiceType {
  static let shared = OAuthService()
  private let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  // MARK: OAuth 2.0 Flow
  
  func webAuthAsync() async throws -> AccessTokenResponse {
    return try await withCheckedThrowingContinuation { continuation in
      webAuth { result in
        switch result {
        case .success(let accessToken):
          continuation.resume(returning: accessToken)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  private func webAuth(completion: @escaping (Result<AccessTokenResponse, Error>) -> Void) {
    let url = OAuthService.getAuthPageUrl()
    let authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: "pocketgg") { callbackURL, error in
      if let error {
        completion(.failure(error))
        return
      }
      guard let callbackURL else {
        completion(.failure(LoginError.noCallbackURL))
        return
      }

      let authCode = URLComponents(string: callbackURL.absoluteString)?.queryItems?.filter({ $0.name == "code" }).first?.value
      guard let authCode else {
        completion(.failure(LoginError.noAuthCode))
        return
      }
      
      Task { [weak self] in
        do {
          guard let accessToken = try await self?.getAccessToken(authCode) else { throw LoginError.selfNil }
          completion(.success(accessToken))
        } catch {
          completion(.failure(error))
        }
      }
    }
    
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      authSession.presentationContextProvider = self
      authSession.start()
    }
  }
  
  // MARK: Get Access Token
  
  private func getAccessToken(_ authCode: String) async throws -> AccessTokenResponse {
    let clientSecret = try await getClientSecret()
    
    let parameters: [String: Any] = [
      "grant_type": "authorization_code",
      "client_secret": clientSecret,
      "code": authCode,
      "scope": "user.identity",
      "client_id": OAuthConstants.clientID,
      "redirect_uri": OAuthConstants.redirectURI
    ]
    
    do {
      return try await requestTokens(token: .accessToken, parameters: parameters)
    } catch {
      throw error
    }
  }
  
  // MARK: Refresh Access Token
  
  func refreshAccessToken() async throws -> AccessTokenResponse {
    let clientSecret = try await getClientSecret()
    var refreshToken = ""
    do {
      refreshToken = try KeychainService.getToken(.refreshToken)
    } catch {
      throw error
    }
    
    let parameters: [String: Any] = [
      "grant_type": "refresh_token",
      "refresh_token": refreshToken,
      "scope": "user.identity",
      "client_id": OAuthConstants.clientID,
      "client_secret": clientSecret,
      "redirect_uri": OAuthConstants.redirectURI
    ]
    
    do {
      return try await requestTokens(token: .refreshToken, parameters: parameters)
    } catch {
      throw error
    }
  }
  
  // MARK: Request Tokens
  
  private func requestTokens(token: Token, parameters: [String: Any]) async throws -> AccessTokenResponse {
    let url: URL
    switch token {
    case .accessToken:
      url = URL(string: OAuthConstants.accessTokenEndpoint)!
    case .refreshToken:
      url = URL(string: OAuthConstants.refreshTokenEndpoint)!
    }
    
    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let response = try? decoder.decode(AccessTokenResponse.self, from: data) {
        return response
      } else {
        #if DEBUG
        print("Unable to decode response in OAuthService.requestTokens():")
        print(String(data: data, encoding: .utf8) as Any)
        #endif
        throw OAuthError.invalidData
      }
    } catch {
      switch error {
      case OAuthError.invalidData:
        throw error
      default:
        #if DEBUG
        print("Data Task error in OAuthService.requestTokens():")
        print(error.localizedDescription)
        #endif
        throw error.is503Error
          ? LoginError.serverUnavailable
          : OAuthError.dataTaskError(error.localizedDescription)
      }
    }
  }
  
  // MARK: Save Tokens
  
  func saveTokens(_ response: AccessTokenResponse) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      do {
        try KeychainService.upsertToken(response.accessToken, .accessToken)
        try KeychainService.upsertToken(response.refreshToken, .refreshToken)
      } catch {
        continuation.resume(throwing: error)
        return
      }

      // By default, tokens expire in 604800 seconds (7 days)
      // Try to get a new access token once every day
      userDefaults.set(Date(), forKey: Constants.accessTokenLastRefreshed)
      
      StartggService.shared.updateApolloClient()
      continuation.resume()
    }
  }
  
  private static func getAuthPageUrl() -> URL {
    let redirectURI = OAuthConstants.redirectURI
    let clientID = OAuthConstants.clientID
    let urlString = "https://start.gg/oauth/authorize?response_type=code&client_id=\(clientID)&scope=user.identity&redirect_uri=\(redirectURI)"
    return URL(string: urlString)!
  }
  
  private func getClientSecret() async throws -> String {
    let request = NSBundleResourceRequest(tags: ["StartggAPI"])
    try await request.beginAccessingResources()
    
    guard let url = Bundle.main.url(forResource: "ClientSecret", withExtension: "txt"),
          let secret = String(data: try Data(contentsOf: url), encoding: .utf8) else {
      request.endAccessingResources()
      throw OAuthError.invalidClientSecret
    }
    
    request.endAccessingResources()
    return secret
  }
  
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return ASPresentationAnchor()
  }
}
