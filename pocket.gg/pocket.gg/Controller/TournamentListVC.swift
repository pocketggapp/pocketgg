//
//  TournamentListVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-05-15.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

class TournamentListVC: UITableViewController {
    
    var tournaments = [Tournament]()
    var doneRequest: Bool
    var noMoreTournaments: Bool
    var imageCache: Cache
    
    // MARK: - Initialization
    
    init(_ tournaments: [Tournament], title: String?) {
        self.tournaments = tournaments
        doneRequest = true
        noMoreTournaments = false
        imageCache = .regular // imageCache is initialized to .regular, but should be re-initialized in subclasses to use the correct cache
        
        super.init(style: .grouped)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TournamentListCell.self, forCellReuseIdentifier: k.Identifiers.tournamentListCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorColor = .clear
    }
    
    // MARK: - Tournament Loading
    
    func loadTournaments() {
        fatalError("This implementation should never get called. Subclasses should override this method and use their own implementation")
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournaments.isEmpty ? 1 : tournaments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !tournaments.isEmpty else {
            if !doneRequest { return LoadingCell(color: .secondarySystemBackground) }
            
            let cell = UITableViewCell().setupDisabled("No tournaments found")
            cell.backgroundColor = .secondarySystemBackground
            return cell
        }
        
        // If we are approaching the end of the list, load more tournaments
        if indexPath.row == tournaments.count - 3 {
            loadTournaments()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.tournamentListCell, for: indexPath) as? TournamentListCell {
            guard let tournament = tournaments[safe: indexPath.row] else {
                return UITableViewCell()
            }
            cell.tag = indexPath.row
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .systemGroupedBackground
            cell.imageView?.image = UIImage(named: "placeholder")
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 2
            var detailText = tournament.date ?? ""
            detailText += tournament.isOnline ?? true ? "\nOnline" : ""
            
            cell.textLabel?.text = tournament.name
            cell.detailTextLabel?.text = detailText
            
            cell.imageView?.layer.cornerRadius = k.Sizes.cornerRadius
            cell.imageView?.layer.masksToBounds = true
            let newSize = CGSize(width: k.Sizes.tournamentListCellHeight, height: k.Sizes.tournamentListCellHeight)
            ImageService.getImage(imageUrl: tournament.logoUrl, cache: imageCache, newSize: newSize) { image in
                DispatchQueue.main.async {
                    guard let imageView = cell.imageView else { return }
                    if cell.tag == indexPath.row {
                        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                            let image = image ?? UIImage(named: "game-controller-square")
                            cell.imageView?.image = image
                        }, completion: nil)
                    }
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }

    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tournament = tournaments[safe: indexPath.row] else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        navigationController?.pushViewController(TournamentVC(tournament, cacheForLogo: imageCache), animated: true)
    }
}
