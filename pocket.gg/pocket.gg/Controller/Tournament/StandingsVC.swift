//
//  StandingsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-04.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class StandingsVC: UITableViewController {
    
    var standings = [Standing]()
    var eventID: Int?
    var doneRequest: Bool
    var noMoreStandings: Bool
    var currentStandingsPage: Int
    
    var lastRefreshTime: Date?
    
    // MARK: - Initialization
    
    init(_ standings: [Standing], eventID: Int?) {
        self.standings = standings
        self.eventID = eventID
        doneRequest = true
        noMoreStandings = false
        currentStandingsPage = 1
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Standings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: k.Identifiers.eventStandingCell)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func loadStandings() {
        guard doneRequest, !noMoreStandings, let id = eventID else {
            refreshControl?.endRefreshing()
            return
        }
        
        currentStandingsPage += 1
        doneRequest = false
        
        TournamentDetailsService.getEventStandings(id, page: currentStandingsPage) { [weak self] standings in
            guard let standings = standings else {
                self?.doneRequest = true
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
                return
            }
            
            guard !standings.isEmpty else {
                self?.doneRequest = true
                self?.noMoreStandings = true
                self?.refreshControl?.endRefreshing()
                return
            }
            
            self?.doneRequest = true
            if let startIndex = self?.standings.count {
                let indexPaths = (startIndex..<(startIndex + standings.count)).map {
                    return IndexPath.init(row: $0, section: 0)
                }
                self?.tableView.performBatchUpdates({
                    self?.standings.append(contentsOf: standings)
                    self?.tableView.insertRows(at: indexPaths, with: .none)
                }, completion: { _ in
                    self?.refreshControl?.endRefreshing()
                })
            } else {
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
            
            // If less standings than expected were returned, then there are no more standings to load
            guard let self = self else { return }
            if standings.count < 65 {
                self.noMoreStandings = true
            }
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
        standings.removeAll()
        tableView.reloadData()
        doneRequest = true
        noMoreStandings = false
        currentStandingsPage = 0
        loadStandings()
    }

    // MARK: - Table View Data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If we are approaching the end of the list, load more standings
        if indexPath.row == standings.count - 3 {
            loadStandings()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.eventStandingCell, for: indexPath)
        cell.selectionStyle = .none
        
        var placement = ""
        if let placementNum = standings[indexPath.row].placement {
            placement = "\(placementNum): "
        }
        
        let entrant = standings[indexPath.row].entrant
        let attributedText = NSMutableAttributedString(string: placement)
        attributedText.append(SetUtilities.getAttributedEntrantText(entrant, bold: false, size: cell.textLabel?.font.pointSize ?? 10,
                                                                    teamNameLength: entrant?.teamName?.count))
        cell.textLabel?.attributedText = attributedText
        
        return cell
    }
}
