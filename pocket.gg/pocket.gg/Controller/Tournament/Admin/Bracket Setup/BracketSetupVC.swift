//
//  BracketSetupVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-09-01.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class BracketSetupVC: UITableViewController {
    
    var event: AdminEvent?
    var doneRequest = false
    var phases: [AdminPhase]?
    
    var deletingPhase: Bool
    
    var lastRefreshTime: Date?
    
    // MARK: - Initialization
    
    init(_ event: AdminEvent?) {
        self.event = event
        deletingPhase = false
        super.init(style: .insetGrouped)
        title = "Bracket Setup"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: k.Identifiers.adminPhaseCell)
        loadPhases()
    }
    
    private func loadPhases() {
        guard let id = event?.id else {
            doneRequest = true
            refreshControl?.endRefreshing()
            tableView.reloadData()
            return
        }
        
        TournamentMutationsService.getPhases(id) { [weak self] phases, error in
            if let error = error {
                // TODO: Handle error
                print(error.localizedDescription)
                return
            }
            guard let phases = phases else {
                // TODO: Handle this
                return
            }
            self?.phases = phases
            self?.doneRequest = true
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
            self?.navigationItem.rightBarButtonItem = phases.isEmpty ? nil : self?.editButtonItem
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshData() {
        if let lastRefreshTime = lastRefreshTime {
            // Don't allow refreshing more than once every 5 seconds
            guard Date().timeIntervalSince(lastRefreshTime) > 5 else {
                refreshControl?.endRefreshing()
                return
            }
        }
        
        lastRefreshTime = Date()
        loadPhases()
    }
    
    private func presentPhaseDeleteErrorAlert(_ error: Error? = nil) {
        deletingPhase = false
        let message: String
        if let error = error {
            message = error.localizedDescription
        } else {
            message = "The phase was unable to be deleted. Please check your internet connection and try again."
        }
        let alert = UIAlertController(title: "Error deleting Phase", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 1 }
        guard doneRequest else { return 1 }
        guard let phases = phases, !phases.isEmpty else { return 1 }
        return phases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        return "Phases"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard doneRequest else { return LoadingCell() }
            guard let phases = phases else { return UITableViewCell().setupDisabled("TODOIEWQRQPEWIR") }
            guard let phase = phases[safe: indexPath.row] else { break }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.adminPhaseCell, for: indexPath) as? SubtitleCell {
                cell.textLabel?.text = phase.name
                cell.accessoryType = .disclosureIndicator
                if let bracketType = phase.bracketType {
                    cell.detailTextLabel?.text = bracketType.replacingOccurrences(of: "_", with: " ").capitalized
                }
                return cell
            }
        case 1:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Add Phase"
            cell.imageView?.image = UIImage(systemName: "plus")
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let phase = phases?[safe: indexPath.row] else { return }
            let message: String
            if let phaseName = phase.name {
                message = "Are you sure you want to delete phase \(phaseName)?"
            } else {
                message = "Are you sure you want to delete this phase?"
            }
            let alert = UIAlertController(title: "Delete Phase", message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                guard let id = phase.id else {
                    self?.presentPhaseDeleteErrorAlert()
                    return
                }
                self?.deletingPhase = true
                TournamentMutationsService.deletePhase(id) { success, error in
                    if let error = error {
                        self?.presentPhaseDeleteErrorAlert(error)
                        return
                    }
                    if success {
                        self?.phases?.remove(at: indexPath.row)
                        if self?.phases?.isEmpty ?? false {
                            self?.navigationItem.rightBarButtonItem = nil
                        }
                    } else {
                        self?.presentPhaseDeleteErrorAlert()
                    }
                    self?.tableView.reloadData()
                    self?.deletingPhase = false
                }
            }))
            // Make the presentation a popover for iPads
            alert.modalPresentationStyle = .popover
            if let popController = alert.popoverPresentationController {
                popController.sourceRect = tableView.rectForRow(at: indexPath)
                popController.sourceView = tableView
            }
            present(alert, animated: true)
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard !deletingPhase else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            guard let phase = phases?[safe: indexPath.row] else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            navigationController?.pushViewController(EditPhaseVC(eventID: event?.id, phase: phase), animated: true)
        case 1:
            let vc = EditPhaseVC(eventID: event?.id, phase: nil)
            vc.phaseEdited = { [weak self] in
                self?.loadPhases()
            }
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        default: tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
