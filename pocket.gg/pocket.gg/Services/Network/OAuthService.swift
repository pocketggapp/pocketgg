//
//  OAuthService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-08-16.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import Foundation

private enum OAuthConstants {
  static let accessTokenEndpoint = "https://api.start.gg/oauth/access_token"
  static let refreshTokenEndpoint = "https://api.start.gg/oauth/refresh"
  static let redirectURI = "https://pocketggapp.github.io"
  static let clientID = "17"
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

final class OAuthService {
  static func getAuthPageUrl() -> URL {
    let redirectURI = OAuthConstants.redirectURI
    let clientID = OAuthConstants.clientID
    let urlString = "https://start.gg/oauth/authorize?response_type=code&client_id=\(clientID)&scope=user.identity&redirect_uri=\(redirectURI)"
//    let urlString2 = "http://start.gg/api/-/rest/oauth/authorize?response_type=code&client_id=\(clientID)&scope=user.identity&redirect_uri=\(redirectURI)&client_secret=\(clientSecret)"
    
    return URL(string: urlString)!
  }
  
  // TODO: Migrate other network calls to use Result type
  static func getAccessToken(_ authCode: String, _ complete: @escaping (Result<AccessTokenResponse, OAuthError>) -> Void) {
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
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      if let error = error {
        complete(.failure(.dataTaskError(error.localizedDescription)))
        return
      }
      guard let data = data else {
        complete(.failure(.noData))
        return
      }
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let response = try? decoder.decode(AccessTokenResponse.self, from: data) {
        complete(.success(response))
        return
      }
      complete(.failure(.invalidData))
    }
    
    task.resume()
  }
  
  // TODO: OAuth - Finish this method
  static func getRefreshToken(_ complete: @escaping (Result<Void, OAuthError>) -> Void) {
    
    let clientSecret = ProcessInfo.processInfo.environment["CLIENT_SECRET"] ?? ""
    let url = URL(string: OAuthConstants.refreshTokenEndpoint)!
    var refreshToken = ""
    do {
      refreshToken = try KeychainService.getToken(.refreshToken)
    } catch {
      // TODO: OAuth - Handle error
    }
    
    let parameters: [String: Any] = [
      "grant_type": "refresh_token",
      "refresh_token": refreshToken,
      "scope": "user.identity",
      "client_id": OAuthConstants.clientID,
      "client_secret": clientSecret,
      "redirect_uri": OAuthConstants.redirectURI
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      if let error = error {
        complete(.failure(.dataTaskError(error.localizedDescription)))
        return
      }
      guard let data = data else {
        complete(.failure(.noData))
        return
      }
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      if let response = try? decoder.decode(AccessTokenResponse.self, from: data) {
        complete(.success(()))
        return
      }
      complete(.failure(.invalidData))
    }
    
    task.resume()
    
  }
}
