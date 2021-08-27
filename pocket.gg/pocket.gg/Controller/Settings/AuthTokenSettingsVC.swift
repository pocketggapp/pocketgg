//
//  AuthTokenSettingsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-05-26.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class AuthTokenSettingsVC: UITableViewController {
    
    let authTokenDate: String?
    
    // MARK: - Initialization
    
    init(_ authTokenDate: String?) {
        self.authTokenDate = authTokenDate
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auth Token"
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let text: String
            if let date = authTokenDate {
                text = "Entered on: " + date
            } else {
                text = "No auth token present"
            }
            return UITableViewCell().setupDisabled(text)
        case 1:
            return UITableViewCell().setupActive(textColor: .label, text: "View Auth Token instructions")
        case 2:
            let cell = UITableViewCell()
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.text = "Clear Auth Token"
            return cell
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current Auth Token" : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1: present(UINavigationController(rootViewController: AuthTokenStepsVC()), animated: true, completion: nil)
        case 2:
            let message = """
            Are you sure you want to clear the current auth token? \
            You will be returned to the login screen where you can enter a new auth token.
            """
            let alert = UIAlertController(title: "Clear Auth Token", message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Clear Auth Token", style: .destructive, handler: { _ in
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                guard let window = sceneDelegate.window else { return }
                
                UserDefaults.standard.removeObject(forKey: k.UserDefaults.authToken)
                UserDefaults.standard.removeObject(forKey: k.UserDefaults.authTokenDate)
                
                window.rootViewController = AuthTokenVC()
                window.makeKeyAndVisible()
                MainTabBarControllerService.deinitTabBarController()
            }))
            // Make the presentation a popover for iPads
            alert.modalPresentationStyle = .popover
            if let popController = alert.popoverPresentationController {
                popController.sourceRect = tableView.rectForRow(at: indexPath)
                popController.sourceView = tableView
            }
            present(alert, animated: true)
        default: return
        }
    }
}
