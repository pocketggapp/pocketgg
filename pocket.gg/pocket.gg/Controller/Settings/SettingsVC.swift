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
    
    var pinnedCell = UITableViewCell()
    var featuredCell = UITableViewCell()
    var upcomingCell = UITableViewCell()
    var videoGameSelectionCell = UITableViewCell()
    var authTokenCell = UITableViewCell()
    var appIconCell = UITableViewCell()
    var firebaseCell = UITableViewCell()
    var aboutCell = UITableViewCell()
    
    let authTokenDate = UserDefaults.standard.string(forKey: k.UserDefaults.authTokenDate)
    
    /// Determines whether the VC can notify MainVC that a setting was changed, and that the tournaments should be reloaded
    /// - Will be initialized to true whenever the view appears
    /// - When a setting is changed, the notification is sent, this is set to false, and is not set to true again until the view disappears
    var canSendNotification = true
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        setupCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canSendNotification = true
    }
    
    // MARK: - Setup
    
    private func setupCells() {
        let pinnedSwitch = UISwitch()
        pinnedSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.showPinnedTournaments)
        pinnedSwitch.addTarget(self, action: #selector(pinnedSwitchToggled(_:)), for: .valueChanged)
        pinnedCell.accessoryView = pinnedSwitch
        pinnedCell.selectionStyle = .none
        pinnedCell.textLabel?.text = "Pinned"
        
        let featuredSwitch = UISwitch()
        featuredSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.featuredTournaments)
        featuredSwitch.addTarget(self, action: #selector(featuredSwitchToggled(_:)), for: .valueChanged)
        featuredCell.accessoryView = featuredSwitch
        featuredCell.selectionStyle = .none
        featuredCell.textLabel?.text = "Featured"
        
        let upcomingSwitch = UISwitch()
        upcomingSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.upcomingTournaments)
        upcomingSwitch.addTarget(self, action: #selector(upcomingSwitchToggled(_:)), for: .valueChanged)
        upcomingCell.accessoryView = upcomingSwitch
        upcomingCell.selectionStyle = .none
        upcomingCell.textLabel?.text = "Upcoming"
        
        videoGameSelectionCell.accessoryType = .disclosureIndicator
        videoGameSelectionCell.textLabel?.text = "Video Game Selection"
        
        authTokenCell.accessoryType = .disclosureIndicator
        authTokenCell.textLabel?.text = "Auth Token"
        
        appIconCell.accessoryType = .disclosureIndicator
        appIconCell.textLabel?.text = "App Icon"
        
        let firebaseSwitch = UISwitch()
        firebaseSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.firebaseEnabled)
        firebaseSwitch.addTarget(self, action: #selector(firebaseSwitchToggled(_:)), for: .valueChanged)
        firebaseCell.accessoryView = firebaseSwitch
        firebaseCell.selectionStyle = .none
        firebaseCell.textLabel?.text = "Crash Reporting & Analytics"
        
        aboutCell.accessoryType = .disclosureIndicator
        aboutCell.textLabel?.text = "About"
    }
    
    // MARK: - Actions
    
    @objc private func pinnedSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.showPinnedTournaments)
        requestTournamentsReload()
    }
    
    @objc private func featuredSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.featuredTournaments)
        requestTournamentsReload()
    }
    
    @objc private func upcomingSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.upcomingTournaments)
        requestTournamentsReload()
    }
    
    @objc private func firebaseSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.firebaseEnabled)
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(sender.isOn)
        Analytics.setAnalyticsCollectionEnabled(sender.isOn)
    }
    
    private func requestTournamentsReload() {
        if canSendNotification {
            NotificationCenter.default.post(name: Notification.Name(k.Notification.settingsChanged), object: nil)
            canSendNotification = false
        }
    }
    
    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1, 2, 3, 4, 5: return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return pinnedCell
            case 1: return featuredCell
            case 2: return upcomingCell
            default: return UITableViewCell()
            }
        case 1: return videoGameSelectionCell
        case 2: return appIconCell
        case 3: return authTokenCell
        case 4: return firebaseCell
        case 5: return aboutCell
        default: return UITableViewCell()
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Tournament Sections" : nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        // TODO: Finalize wording
        case 0: return "Enable/Disable these to show/hide the various sections on the main screen"
        case 1: return "Only tournaments that feature events with at least 1 of the video games selected here will show up on the main screen"
        case 3:
            if let date = authTokenDate {
                return "Auth Token entered on " + date
            } else {
                return "No auth token present"
            }
        case 4:
            return """
            Enables anonymous crash reporting & analytics for pocket.gg. This greatly helps for debugging app crashes or other issues, \
            such as potential errors when generating a tournament event bracket view.
            """
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1: navigationController?.pushViewController(VideoGamesVC(), animated: true)
        case 2: navigationController?.pushViewController(AppIconVC(), animated: true)
        case 3: navigationController?.pushViewController(AuthTokenSettingsVC(authTokenDate), animated: true)
        case 5: navigationController?.pushViewController(AboutVC(style: .insetGrouped), animated: true)
        default: return
        }
    }
}
