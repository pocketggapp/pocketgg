//
//  AdminSettingsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-08-31.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class AdminSettingsVC: UITableViewController {
    
    var tournamentID: Int?
    
    // MARK: - Initialization
    
    init(_ tournamentID: Int?) {
        self.tournamentID = tournamentID
        super.init(style: .insetGrouped)
        title = "Admin Settings"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let text: String?
        switch indexPath.row {
        case 0: text = "Bracket Setup"
        default: text = nil
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = text
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: navigationController?.pushViewController(EventListVC(tournamentID), animated: true)
        default: tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
