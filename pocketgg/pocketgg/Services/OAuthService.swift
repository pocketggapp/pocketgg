import Foundation
import AuthenticationServices

private enum OAuthConstants {
  static let accessTokenEndpoint = "https://api.start.gg/oauth/access_token"
  static let refreshTokenEndpoint = "https://api.start.gg/oauth/refresh"
  static let redirectURI = "https://pocketggapp.github.io"
  static let clientID = "17"
}

enum LoginError: Error {
  case noCallbackURL
  case noAuthCode
  case selfNil
}

enum OAuthError: Error {
  case dataTaskError(String)
  case noData
  case invalidData
}

struct AccessTokenResponse: Codable {
  let accessToken: String
  let tokenType: String
  let expiresIn: Int
  let refreshToken: String
}

final class OAuthService: NSObject, ASWebAuthenticationPresentationContextProviding {
  
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
  
  private func getAccessToken(_ authCode: String) async throws -> AccessTokenResponse {
    let clientSecret = ProcessInfo.processInfo.environment["CLIENT_SECRET"] ?? ""
    let url = URL(string: OAuthConstants.accessTokenEndpoint)!
    
    let parameters: [String: Any] = [
      "grant_type": "authorization_code",
      "client_secret": clientSecret,
      "code": authCode,
      "scope": "user.identity",
      "client_id": OAuthConstants.clientID,
      "redirect_uri": OAuthConstants.redirectURI
    ]
    
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
        throw OAuthError.invalidData
      }
    } catch {
      throw OAuthError.dataTaskError(error.localizedDescription)
    }
  }
  
  private static func getAuthPageUrl() -> URL {
    let redirectURI = OAuthConstants.redirectURI
    let clientID = OAuthConstants.clientID
    let urlString = "https://start.gg/oauth/authorize?response_type=code&client_id=\(clientID)&scope=user.identity&redirect_uri=\(redirectURI)"
    return URL(string: urlString)!
  }
  
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return ASPresentationAnchor()
  }
}
