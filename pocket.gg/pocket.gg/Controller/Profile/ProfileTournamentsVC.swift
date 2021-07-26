//
//  ProfileTournamentsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-25.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class ProfileTournamentsVC: TournamentListVC {
    
    var currentTournamentsPage: Int
    var numTournamentsToLoad: Int
    
    // MARK: - Initialization
    
    init(_ tournaments: [Tournament], numTournamentsToLoad: Int) {
        currentTournamentsPage = 1
        self.numTournamentsToLoad = numTournamentsToLoad
        
        super.init(tournaments, title: "My Tournaments")
        imageCache = .profileTournaments
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Additional Tournament Loading
    
    override func loadTournaments() {
        guard doneRequest else { return }
        guard !noMoreTournaments else { return }
        
        currentTournamentsPage += 1
        doneRequest = false
        
        ProfileService.getProfileTournaments(page: currentTournamentsPage, perPage: numTournamentsToLoad) { [weak self] (tournaments) in
            guard let tournaments = tournaments else {
                self?.doneRequest = true
                self?.tableView.reloadData()
                return
            }
            
            // If no tournaments were returned, then there are no more tournaments to load
            guard !tournaments.isEmpty else {
                self?.doneRequest = true
                self?.noMoreTournaments = true
                return
            }
            
            self?.doneRequest = true
            if let startIndex = self?.tournaments.count {
                let indexPaths = (startIndex..<(startIndex + tournaments.count)).map {
                    return IndexPath.init(row: $0, section: 0)
                }
                self?.tableView.performBatchUpdates({
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
