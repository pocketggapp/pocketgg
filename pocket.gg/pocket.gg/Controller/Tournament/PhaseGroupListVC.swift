//
//  PhaseGroupListVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-08-25.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class PhaseGroupListVC: UITableViewController {
    
    var phase: Phase
    var doneRequest = false
    var requestSuccessful = true
    
    var lastRefreshTime: Date?
    
    var IDs: TournamentIDs

    // MARK: - Initialization
    
    init(phase: Phase, IDs: TournamentIDs) {
        self.phase = phase
        self.IDs = IDs
        self.IDs.phaseID = phase.id
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = phase.name
        tableView.register(Value1Cell.self, forCellReuseIdentifier: k.Identifiers.value1Cell)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        loadPhaseGroups()
    }
    
    private func loadPhaseGroups() {
        guard let id = phase.id else {
            doneRequest = true
            requestSuccessful = false
            refreshControl?.endRefreshing()
            tableView.reloadData()
            return
        }
        
        TournamentDetailsService.getPhaseGroups(id, numPhaseGroups: phase.numPhaseGroups ?? 90) { [weak self] (result) in
            guard let result = result else {
                self?.doneRequest = true
                self?.requestSuccessful = false
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
                return
            }
            
            self?.phase.phaseGroups = result
            
            self?.doneRequest = true
            self?.requestSuccessful = true
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    @objc private func refreshData() {
        if let lastRefreshTime = lastRefreshTime {
            // Don't allow refreshing more than once every 5 seconds
            guard Date().timeIntervalSince(lastRefreshTime) > 5 else {
                refreshControl?.endRefreshing()
                return
            }
        }
        
        lastRefreshTime = Date()
        loadPhaseGroups()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            guard doneRequest, requestSuccessful else { return 1 }
            guard let phaseGroups = phase.phaseGroups, !phaseGroups.isEmpty else { return 1 }
            return phaseGroups.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            
            cell.selectionStyle = .none
            cell.textLabel?.text = phase.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: k.Sizes.largeFont)
            
            var detailTextStrings = [String]()
            if let numEntrants = phase.numEntrants {
                detailTextStrings.append("\(numEntrants) entrants")
            }
            if let numPools = phase.numPhaseGroups {
                detailTextStrings.append("\(numPools) pools")
            }
            if let bracketType = phase.bracketType {
                detailTextStrings.append(bracketType.replacingOccurrences(of: "_", with: " ").capitalized)
            }
            
            let detailText: String = detailTextStrings.enumerated().reduce("") { (accumulate, current) -> String in
                return accumulate + current.1 + (current.0 != detailTextStrings.endIndex - 1 ? " • " : "")
            }
            cell.detailTextLabel?.text = detailText
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            
            return cell
            
        case 1:
            guard doneRequest else { return LoadingCell() }
            guard requestSuccessful, let phaseGroups = phase.phaseGroups else { return UITableViewCell().setupDisabled(k.Message.errorLoadingPhaseGroups) }
            guard !phaseGroups.isEmpty else { return UITableViewCell().setupDisabled(k.Message.noPhaseGroups) }
            guard let phaseGroup = phaseGroups[safe: indexPath.row] else { break }

            if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.value1Cell, for: indexPath) as? Value1Cell {
                cell.accessoryType = .disclosureIndicator
                var text: String?
                if let poolId = phaseGroup.name {
                    text = "Pool " + poolId
                }
                cell.updateLabels(text: text, detailText: phaseGroup.state?.capitalized)
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        guard let phaseGroup = phase.phaseGroups?[safe: indexPath.row] else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        navigationController?.pushViewController(PhaseGroupVC(phaseGroup, title: "Pool " + (phaseGroup.name ?? ""), IDs: IDs), animated: true)
    }
}
