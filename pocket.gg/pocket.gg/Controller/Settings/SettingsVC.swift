//
//  SettingsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-12.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import FirebaseAnalytics

final class SettingsVC: UITableViewController {

  private var locationCell = UITableViewCell()
  private var appIconCell = UITableViewCell()
  private var authTokenCell = UITableViewCell()
  private var firebaseCell = UITableViewCell()
  private var rateCell = UITableViewCell()
  private var aboutCell = UITableViewCell()

  private let authTokenDate = UserDefaults.standard.string(forKey: k.UserDefaults.authTokenDate)

  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Settings"
    setupCells()
  }

  // MARK: Setup

  private func setupCells() {
    locationCell.accessoryType = .disclosureIndicator
    locationCell.textLabel?.text = "Location"
    locationCell.imageView?.image = UIImage(systemName: "location.fill")

    appIconCell.accessoryType = .disclosureIndicator
    appIconCell.textLabel?.text = "App Icon"
    appIconCell.imageView?.image = UIImage(systemName: "app.badge.fill")

    authTokenCell.accessoryType = .disclosureIndicator
    authTokenCell.textLabel?.text = "Auth Token"
    authTokenCell.imageView?.image = UIImage(systemName: "key.fill")

    let firebaseSwitch = UISwitch()
    firebaseSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.firebaseEnabled)
    firebaseSwitch.addTarget(self, action: #selector(firebaseSwitchToggled(_:)), for: .valueChanged)
    firebaseCell.accessoryView = firebaseSwitch
    firebaseCell.selectionStyle = .none
    firebaseCell.textLabel?.text = "Crash Reporting & Analytics"
    firebaseCell.textLabel?.numberOfLines = 0
    firebaseCell.imageView?.image = UIImage(systemName: "ant.fill")

    rateCell.accessoryType = .disclosureIndicator
    rateCell.textLabel?.text = "Rate pocket.gg"
    rateCell.imageView?.image = UIImage(systemName: "heart.fill")

    aboutCell.accessoryType = .disclosureIndicator
    aboutCell.textLabel?.text = "About"
    aboutCell.imageView?.image = UIImage(systemName: "info.circle.fill")
  }

  // MARK: Actions

  @objc private func firebaseSwitchToggled(_ sender: UISwitch) {
    UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.firebaseEnabled)
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(sender.isOn)
    Analytics.setAnalyticsCollectionEnabled(sender.isOn)

    let title = "Crash Reporting & Analytics " + (sender.isOn ? "Enabled" : "Disabled")
    let alert = UIAlertController(title: title, message: "Please restart the app for your changes to take effect", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    present(alert, animated: true)
  }

  // MARK: Table View Data Source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0, 1, 2, 3: return 1
    case 4: return 2
    default: return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return locationCell
    case 1: return appIconCell
    case 2: return authTokenCell
    case 3: return firebaseCell
    case 4:
      switch indexPath.row {
      case 0: return rateCell
      case 1: return aboutCell
      default: break
      }
      return aboutCell
    default: break
    }
    return UITableViewCell()
  }

  // MARK: Table View Delegate

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    switch section {
    case 0: return """
    Choose a location to only load tournaments in the specified country/state. \
    The Featured Tournaments section and tournament search function are not affected by the chosen location.
    """
    case 2:
      if let date = authTokenDate {
        return "Auth Token entered on " + date
      } else {
        return "No auth token present"
      }
    case 3:
      return """
      Enables anonymous crash reporting & analytics for pocket.gg. This greatly helps for debugging app crashes or other issues, \
      such as potential errors when generating a tournament event bracket view.
      """
    default: return nil
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0: navigationController?.pushViewController(LocationVC(), animated: true)
    case 1: navigationController?.pushViewController(AppIconVC(), animated: true)
    case 2: navigationController?.pushViewController(AuthTokenSettingsVC(authTokenDate), animated: true)
    case 4:
      switch indexPath.row {
      case 0:
        guard let url = URL(string: k.URL.appStore) else {
          tableView.deselectRow(at: indexPath, animated: true)
          return
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return }
        UIApplication.shared.open(writeReviewURL)
        tableView.deselectRow(at: indexPath, animated: true)
      case 1: navigationController?.pushViewController(AboutVC(style: .insetGrouped), animated: true)
      default: tableView.deselectRow(at: indexPath, animated: true)
      }
    default: return
    }
  }
}
