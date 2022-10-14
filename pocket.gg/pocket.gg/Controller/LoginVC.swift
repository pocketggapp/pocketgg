//
//  LoginVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-09-23.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit
import SwiftUI
import AuthenticationServices

private enum LoginConstants {
  static let noData = "No response sent by server"
  static let invalidData = "Invalid response sent by server"
  static let noCallbackURL = "No callback URL"
  static let noAuthCode = "No auth code"
}

final class LoginVC: UIViewController {
  
  private let viewModel: LoginViewModel
  private let bottomStackView = UIStackView()
  private var titleCenterConstraint = NSLayoutConstraint()
  private var titleTopConstraint = NSLayoutConstraint()
    
  // MARK: Initialization
    
  init(_ viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Wait for launch screen fade animation to finish, then animate the logo up
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      self?.animateLogoUp()
    }
  }
  
  private func animateLogoUp() {
    view.layoutIfNeeded()
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      self?.titleCenterConstraint.isActive = false
      self?.titleTopConstraint.isActive = true
      self?.view.layoutIfNeeded()
    }, completion: { [weak self] _ in
      UIView.animate(withDuration: 0.3) {
        self?.bottomStackView.alpha = 1.0
      }
    })
  }
  
  // MARK: Setup
  
  private func setupViews() {
    let topStackView = viewModel.setupTopStackView()
    view.addSubview(topStackView)
    topStackView.setAxisConstraints(xAnchor: view.centerXAnchor)
    
    let constraintOffset = (UIScreen.main.bounds.height / 2) - (k.Sizes.logoSideLength / 2)
    titleCenterConstraint = topStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: constraintOffset)
    titleCenterConstraint.isActive = true
    titleTopConstraint = topStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
    
    let buttons = viewModel.setupButtons()
    buttons[0].addTarget(self, action: #selector(logIn), for: .touchUpInside)
    buttons[1].addTarget(self, action: #selector(register), for: .touchUpInside)
    buttons[2].addTarget(self, action: #selector(continueWithoutLoggingIn), for: .touchUpInside)
    
    bottomStackView.setup(subviews: buttons, axis: .vertical, alignment: .fill, spacing: 10)
    view.addSubview(bottomStackView)
    bottomStackView.setEdgeConstraints(
      bottom: view.safeAreaLayoutGuide.bottomAnchor,
      leading: view.safeAreaLayoutGuide.leadingAnchor,
      trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    )
    
    var bottomStackViewHeight: CGFloat = 0
    bottomStackViewHeight += 3 * k.Sizes.buttonHeight
    bottomStackViewHeight += 10
    bottomStackView.heightAnchor.constraint(equalToConstant: bottomStackViewHeight).isActive = true
    bottomStackView.alpha = 0
  }
  
  // MARK: Actions
  
  @objc private func logIn() {
    print("log in")
    let session = viewModel.authSession { [weak self] result in
      switch result {
      case .success(let response):
        self?.viewModel.saveTokens(response, { result in
          switch result {
          case .success():
            DispatchQueue.main.async {
              self?.transitionToNextVC()
            }
          case .failure(let error):
            self?.presentAlert(error)
          }
        })
      case .failure(let error):
        self?.presentAlert(error)
      }
    }
    session.presentationContextProvider = self
    session.start()
  }
  
  @objc private func register() {
    print("register")
  }
  
  @objc private func continueWithoutLoggingIn() {
    print("contineu without log in")
  }

  private func transitionToNextVC() {
    let viewController: UIViewController?
    if UserDefaults.standard.bool(forKey: k.UserDefaults.returningUser) {
      viewController = MainTabBarControllerService.initTabBarController()
    } else {
      let viewModel = OnboardingViewModel<AnyHashable>(content: OnboardingContentFactory.generateOnboardingContent())
      viewController = UIHostingController(rootView: OnboardingView(viewModel: viewModel, flowType: .firstTimeOnboarding))
    }

    MainTabBarControllerService.switchRootViewController(viewController)
  }

  private func presentAlert(_ error: Error) {
    let message: String
    switch error {
    case OAuthError.dataTaskError(let description):
      message = description
    case OAuthError.noData:
      message = LoginConstants.noData
    case OAuthError.invalidData:
      message = LoginConstants.invalidData
    case LoginError.noCallbackURL:
      message = LoginConstants.noCallbackURL
    case LoginError.noAuthCode:
      message = LoginConstants.noAuthCode
    default:
      message = error.localizedDescription
    }

    let alert = UIAlertController(title: k.Error.title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    present(alert, animated: true)
  }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension LoginVC: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return view.window!
  }
}
