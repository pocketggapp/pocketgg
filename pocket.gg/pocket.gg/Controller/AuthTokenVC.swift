//
//  AuthTokenVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-09-23.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class AuthTokenVC: UIViewController {
    
    var titleStackView = UIStackView(frame: .zero)
    var bottomStackView = UIStackView(frame: .zero)
    let authTokenField = UITextField(frame: .zero)
    
    var titleCenterConstraint = NSLayoutConstraint()
    var titleTopConstraint = NSLayoutConstraint()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupKeyboardToolbar()
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
    
    // MARK: - Setup
    
    private func setupViews() {
        let logoImageView = UIImageView(image: UIImage(named: "tournament-red"))
        let appNameLabel = UILabel(frame: .zero)
        appNameLabel.text = "pocket.gg"
        appNameLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        
        titleStackView = UIStackView(arrangedSubviews: [logoImageView, appNameLabel])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .center
        view.addSubview(titleStackView)
        titleStackView.setAxisConstraints(xAnchor: view.centerXAnchor)
        let constraintOffset = (UIScreen.main.bounds.height / 2) - (logoImageView.intrinsicContentSize.height / 2)
        titleCenterConstraint = titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: constraintOffset)
        titleCenterConstraint.isActive = true
        titleTopConstraint = titleStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        
        authTokenField.placeholder = "Auth Token"
        authTokenField.backgroundColor = .secondarySystemBackground
        authTokenField.textAlignment = .left
        authTokenField.borderStyle = .roundedRect
        authTokenField.clearButtonMode = .whileEditing
        authTokenField.addTarget(self, action: #selector(verifyAuthToken), for: .editingDidEndOnExit)
        
        let authTokenStepsButton = UIButton(type: .system)
        authTokenStepsButton.setTitle("How do I get an Auth Token?", for: .normal)
        authTokenStepsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        authTokenStepsButton.contentHorizontalAlignment = .leading
        authTokenStepsButton.setTitleColor(.systemRed, for: .normal)
        authTokenStepsButton.addTarget(self, action: #selector(presentAuthTokenStepsVC), for: .touchUpInside)
        
        let submitButton = UIButton(type: .roundedRect)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemRed
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: #selector(verifyAuthToken), for: .touchUpInside)
        
        bottomStackView.setup(subviews: [authTokenField, authTokenStepsButton, submitButton], axis: .vertical, alignment: .fill, spacing: 5)
        view.addSubview(bottomStackView)
        bottomStackView.setEdgeConstraints(top: titleStackView.bottomAnchor,
                                           leading: view.safeAreaLayoutGuide.leadingAnchor,
                                           trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                           padding: UIEdgeInsets(top: 50, left: 16, bottom: 0, right: 16))
        
        var bottomStackViewHeight: CGFloat = 0
        bottomStackViewHeight += authTokenField.intrinsicContentSize.height
        bottomStackViewHeight += authTokenStepsButton.intrinsicContentSize.height
        bottomStackViewHeight += submitButton.intrinsicContentSize.height
        bottomStackViewHeight += 10
        bottomStackView.heightAnchor.constraint(equalToConstant: bottomStackViewHeight).isActive = true
        bottomStackView.alpha = 0
    }
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let pasteItem = UIBarButtonItem(title: "Paste", style: .plain, target: self, action: #selector(pasteClipboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([pasteItem, flexibleSpace, doneItem], animated: false)
        authTokenField.inputAccessoryView = toolbar
    }
    
    // MARK: - Actions
    
    @objc private func pasteClipboard() {
        guard UIPasteboard.general.hasStrings else { return }
        guard let contents = UIPasteboard.general.string else { return }
        authTokenField.text = (authTokenField.text ?? "") + contents
    }
    
    @objc private func dismissKeyboard() {
        authTokenField.resignFirstResponder()
    }
    
    @objc private func presentAuthTokenStepsVC() {
        present(UINavigationController(rootViewController: AuthTokenStepsVC()), animated: true, completion: nil)
    }
    
    @objc private func verifyAuthToken() {
        dismissKeyboard()
        UserDefaults.standard.set(authTokenField.text, forKey: k.UserDefaults.authToken)
        ApolloService.shared.updateApolloClient()
        NetworkService.isAuthTokenValid { [weak self] valid in
            if valid {
                UserDefaults.standard.set(DateFormatter.shared.dateFromTimestamp("\(Int(Date().timeIntervalSince1970))"), forKey: k.UserDefaults.authTokenDate)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                guard let window = sceneDelegate.window else { return }
                window.rootViewController = MainTabBarControllerService.initTabBarController()
                window.makeKeyAndVisible()
            } else {
                UserDefaults.standard.removeObject(forKey: k.UserDefaults.authToken)
                let alert = UIAlertController(title: k.Error.title, message: k.Error.invalidAuthToken, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
}
