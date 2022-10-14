//
//  LoginViewModel.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-08-12.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import UIKit
import AuthenticationServices

enum LoginError: Error {
  case noCallbackURL
  case noAuthCode
}

final class LoginViewModel {
  
  // MARK: Setup
  
  func setupTopStackView() -> UIStackView {
    let logoImageView = UIImageView(image: UIImage(named: "tournament-red"))
    logoImageView.setSquareAspectRatio(sideLength: k.Sizes.logoSideLength)
    let appNameLabel = UILabel(frame: .zero)
    appNameLabel.text = "pocket.gg"
    appNameLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
    
    let stackView = UIStackView(arrangedSubviews: [logoImageView, appNameLabel])
    stackView.axis = .horizontal
    stackView.alignment = .center
    
    return stackView
  }
  
  func setupButtons() -> [UIButton] {
    var buttons = [UIButton]()
    
    let logInButton = UIButton(type: .roundedRect)
    logInButton.setTitle("Log in with start.gg", for: .normal)
    logInButton.setTitleColor(.white, for: .normal)
    logInButton.backgroundColor = .systemRed
    logInButton.layer.cornerRadius = 5
    logInButton.heightAnchor.constraint(equalToConstant: k.Sizes.buttonHeight).isActive = true
    
    let registerButton = UIButton(type: .roundedRect)
    registerButton.setTitle("Register with start.gg", for: .normal)
    registerButton.setTitleColor(.white, for: .normal)
    registerButton.backgroundColor = .systemRed
    registerButton.layer.cornerRadius = 5
    registerButton.heightAnchor.constraint(equalToConstant: k.Sizes.buttonHeight).isActive = true
    
    let continueButton = UIButton(type: .system)
    continueButton.setTitle("Continue without logging in", for: .normal)
    continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    continueButton.setTitleColor(.systemRed, for: .normal)
    continueButton.heightAnchor.constraint(equalToConstant: k.Sizes.buttonHeight).isActive = true
    
    buttons.append(logInButton)
    buttons.append(registerButton)
    buttons.append(continueButton)
    return buttons
  }
  
  // MARK: Auth Session

  func authSession(_ complete: @escaping (Result<AccessTokenResponse, Error>) -> Void) -> ASWebAuthenticationSession {
    let url = OAuthService.getAuthPageUrl()
    return ASWebAuthenticationSession(url: url, callbackURLScheme: "pocketgg") { callbackURL, error in
      if let error = error {
        complete(.failure(error))
        return
      }
      guard let callbackURL = callbackURL else {
        complete(.failure(LoginError.noCallbackURL))
        return
      }
      
      let authCode = URLComponents(string: callbackURL.absoluteString)?.queryItems?.filter({ $0.name == "code" }).first?.value
      guard let authCode = authCode else {
        complete(.failure(LoginError.noAuthCode))
        return
      }

      OAuthService.getAccessToken(authCode) { result in
        switch result {
        case .success(let response):
          complete(.success(response))
        case .failure(let error):
          complete(.failure(error))
        }
      }
    }
  }

  func saveTokens(_ response: AccessTokenResponse, _ complete: @escaping (Result<Void, Error>) -> Void) {
    // By default, tokens expire in 604800 seconds (7 days)
    // Try to get a new access token 1 day (86400 seconds) early
    let lifetime = TimeInterval(response.expiresIn - 86400)
    UserDefaults.standard.set(Date().addingTimeInterval(lifetime), forKey: k.UserDefaults.accessTokenLifetime)

    do {
      try KeychainService.upsertToken(response.accessToken, .accessToken)
      try KeychainService.upsertToken(response.refreshToken, .refreshToken)
    } catch {
      complete(.failure(error))
      return
    }
    
    ApolloService.shared.updateApolloClient()
    complete(.success(()))
  }
}
