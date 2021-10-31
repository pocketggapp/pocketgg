//
//  EventListVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-08-31.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class EventListVC: UITableViewController {
    
    var tournamentID: Int?
    var doneRequest = false
    var events: [AdminEvent]?
    
    var lastRefreshTime: Date?

    // MARK: - Initialization
    
    init(_ tournamentID: Int?) {
        self.tournamentID = tournamentID
        super.init(style: .insetGrouped)
        title = "Events"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: k.Identifiers.adminEventCell)
        loadEvents()
    }
    
    private func loadEvents() {
        guard let id = tournamentID else {
            doneRequest = true
            refreshControl?.endRefreshing()
            tableView.reloadData()
            return
        }
        
        TournamentMutationsService.getEvents(id) { [weak self] events, error in
            if let error = error {
                // TODO: Handle error
                print(error.localizedDescription)
                return
            }
            guard let events = events else {
                // TODO: Handle this
                return
            }
            self?.events = events
            self?.doneRequest = true
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
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
        loadEvents()
    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard doneRequest else { return 1 }
        guard let events = events, !events.isEmpty else { return 1 }
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard doneRequest else { return LoadingCell() }
        guard let events = events else { return UITableViewCell().setupDisabled("TODOQOIWERUPOWERQ") }
        guard let event = events[safe: indexPath.row] else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.adminEventCell) as? SubtitleCell {
            cell.accessoryType = .disclosureIndicator
            cell.imageView?.image = UIImage(named: "game-controller")
            
            cell.updateView(text: event.name, imageInfo: event.videogameImage, detailText: nil, newRatio: k.Sizes.eventImageRatio)
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = events?[safe: indexPath.row] else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        navigationController?.pushViewController(BracketSetupVC(event), animated: true)
    }
}
