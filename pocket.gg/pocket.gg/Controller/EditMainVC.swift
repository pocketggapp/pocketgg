//
//  EditMainVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-01-21.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import UIKit

final class EditMainVC: UITableViewController {
    
    // MARK: - Initialization
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveChanges))
        
        setEditing(true, animated: false)
//        let pinnedSwitch = UISwitch()
//        pinnedSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.showPinnedTournaments)
//        pinnedSwitch.addTarget(self, action: #selector(pinnedSwitchToggled(_:)), for: .valueChanged)
//        pinnedCell.accessoryView = pinnedSwitch
//        pinnedCell.selectionStyle = .none
//        pinnedCell.textLabel?.text = "Pinned"
//        pinnedCell.imageView?.image = UIImage(systemName: "pin.fill")
//
//        let featuredSwitch = UISwitch()
//        featuredSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.featuredTournaments)
//        featuredSwitch.addTarget(self, action: #selector(featuredSwitchToggled(_:)), for: .valueChanged)
//        featuredCell.accessoryView = featuredSwitch
//        featuredCell.selectionStyle = .none
//        featuredCell.textLabel?.text = "Featured"
//        featuredCell.imageView?.image = UIImage(systemName: "star.fill")
//
//        let upcomingSwitch = UISwitch()
//        upcomingSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.upcomingTournaments)
//        upcomingSwitch.addTarget(self, action: #selector(upcomingSwitchToggled(_:)), for: .valueChanged)
//        upcomingCell.accessoryView = upcomingSwitch
//        upcomingCell.selectionStyle = .none
//        upcomingCell.textLabel?.text = "Upcoming"
//        upcomingCell.imageView?.image = UIImage(systemName: "hourglass")
    }
    
    // MARK: - Actions
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveChanges() {
        // TODO: f
//        if pinnedTournamentsEdited {
//            PinnedTournamentsService.updatePinnedTournaments(pinnedTournaments)
//            NotificationCenter.default.post(name: Notification.Name(k.Notification.tournamentPinToggled), object: nil)
//        }
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Enabled Sections"
        case 1: return "Disabled Sections"
        default: return nil
        }
    }
}
