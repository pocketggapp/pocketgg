//
//  TournamentsByTOVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-27.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class TournamentsByTOVC: TournamentListVC {
    
    var id: Int?
    var name: String?
    var prefix: String?

    var currentTournamentsPage: Int
    var numTournamentsToLoad: Int
    
    var followingTO: Bool
    var followStatusChanged: Bool
    
    // MARK: - Initialization
    
    init(id: Int?, name: String?, prefix: String?) {
        self.id = id
        self.name = name
        self.prefix = prefix
        currentTournamentsPage = 0
        let longEdgeLength = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        //TODO: find actual num instead of 20
        numTournamentsToLoad = max(20, 2 * Int(longEdgeLength / k.Sizes.tournamentListCellHeight))
        
        followingTO = TOFollowedService.alreadyFollowingTO(id ?? -1)
        followStatusChanged = false
        
        var title = ""
        if let prefix = prefix {
            title = prefix + " "
        }
        if let name = name {
            title += name
        }
        super.init([], title: title)
        imageCache = .tournamentsByTO
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = id {
            let title = TOFollowedService.alreadyFollowingTO(id) ? "Unfollow" : "Follow"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(followButtonTapped))
        }
        loadTournaments()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if followStatusChanged {
            NotificationCenter.default.post(name: Notification.Name(k.Notification.followedTournamentOrganizer), object: nil)
            followStatusChanged = false
        }
    }
    
    // MARK: - Actions
    
    @objc private func followButtonTapped() {
        if !TOFollowedService.toggleFollowedTO(TournamentOrganizer(id: id, name: name, prefix: prefix)) {
            // TODO: Show error
            return
        }
        followingTO.toggle()
        followStatusChanged.toggle()
        navigationItem.rightBarButtonItem?.title = followingTO ? "Unfollow" : "Follow"
    }
    
    // MARK: - Tournament Loading
    
    override func loadTournaments() {
        guard doneRequest else { return }
        guard !noMoreTournaments else { return }
        guard let id = id else { return }
        
        currentTournamentsPage += 1
        doneRequest = false
        
        TournamentDetailsService.getTournamentsByTO(id: id, page: currentTournamentsPage, perPage: numTournamentsToLoad) { [weak self] (tournaments) in
            guard let tournaments = tournaments else {
                self?.doneRequest = true
                self?.tableView.reloadData()
                return
            }
            
            // If no tournaments were returned, then there are no more tournaments to load
            guard !tournaments.isEmpty else {
                self?.doneRequest = true
                self?.noMoreTournaments = true
                // Only reload the table view if no tournaments were ever returned
                // (To change the LoadingCell to a "No tournaments found" cell)
                if let noTournaments = self?.tournaments.isEmpty, noTournaments {
                    self?.tableView.reloadData()
                }
                return
            }
            
            self?.doneRequest = true
            if let startIndex = self?.tournaments.count {
                let indexPaths = (startIndex..<(startIndex + tournaments.count)).map {
                    return IndexPath.init(row: $0, section: 0)
                }
                self?.tableView.performBatchUpdates({
                    if let deleteLoadingCell = self?.tournaments.isEmpty, deleteLoadingCell {
                        self?.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                    }
                    self?.tournaments.append(contentsOf: tournaments)
                    self?.tableView.insertRows(at: indexPaths, with: .none)
                }, completion: nil)
            } else {
                self?.tableView.reloadData()
            }
            
            // If less tournaments than expected were returned, then there are no more tournaments to load
            guard let self = self else { return }
            if tournaments.count < self.numTournamentsToLoad {
                self.noMoreTournaments = true
            }
        }
    }
}
