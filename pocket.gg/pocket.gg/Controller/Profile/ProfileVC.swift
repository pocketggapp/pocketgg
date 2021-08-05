//
//  ProfileVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-21.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class ProfileVC: UITableViewController {
    
    let profileCell: ProfileCell
    var imageURL: String?
    var userName: String?
    var userTeamName: String?
    var userBio: String?
    
    var tournaments: [Tournament]
    let numTournamentsToLoad: Int
    
    var initialDataLoaded = false
    var doneRequest = false
    var requestSuccessful = true
    
    var lastRefreshTime: Date?
    
    // MARK: - Initialization
    
    init() {
        profileCell = ProfileCell()
        tournaments = []
        let longEdgeLength = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        //TODO: find actual num instead of 20
        numTournamentsToLoad = max(20, 2 * Int(longEdgeLength / k.Sizes.tournamentListCellHeight))
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        tableView.separatorColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImageService.clearCache(.profileTournaments)
        guard !initialDataLoaded else { return }
        loadProfileData()
    }
    
    private func loadProfileData() {
        initialDataLoaded = true
        ProfileService.getProfile(perPage: numTournamentsToLoad) { [weak self] (result) in
            guard let result = result else {
                self?.doneRequest = true
                self?.requestSuccessful = false
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
                return
            }
            
            self?.imageURL = result["imageURL"] as? String
            self?.userName = result["name"] as? String
            self?.userTeamName = result["teamName"] as? String
            self?.userBio = result["bio"] as? String
            self?.tournaments = result["tournaments"] as? [Tournament] ?? []
            
            self?.doneRequest = true
            self?.requestSuccessful = true
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc private func viewAllTournaments() {
        navigationController?.pushViewController(ProfileTournamentsVC(tournaments, numTournamentsToLoad: numTournamentsToLoad), animated: true)
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
        loadProfileData()
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
            guard !tournaments.isEmpty else { return 1 }
            guard tournaments.count > 10 else { return tournaments.count }
            return 10
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        
        let headerView = UIView()
        
        let textLabel = UILabel()
        textLabel.text = "My Tournaments"
        textLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        headerView.addSubview(textLabel)
        textLabel.setEdgeConstraints(top: headerView.topAnchor,
                                     bottom: headerView.bottomAnchor,
                                     leading: headerView.leadingAnchor,
                                     padding: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 0))
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(button)
        button.setEdgeConstraints(top: headerView.topAnchor,
                                  bottom: headerView.bottomAnchor,
                                  trailing: headerView.trailingAnchor,
                                  padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 16))
        
        // If there are more than 10 tournaments in a section, show the "View All" button
        // To make the vertical spacing consistent, the "View All" button is always added (just not visible when there are 10 or less tournaments)
        if tournaments.count > 10 {
            button.setTitle("View All", for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            button.addTarget(self, action: #selector(viewAllTournaments), for: .touchUpInside)
            button.leadingAnchor.constraint(greaterThanOrEqualTo: textLabel.trailingAnchor, constant: 5).isActive = true
        } else {
            textLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard doneRequest else { return LoadingCell() }
            guard requestSuccessful else { return UITableViewCell().setupDisabled(k.Message.errorLoadingProfile) }
            
            let text = SetUtilities.getAttributedEntrantText(Entrant(id: nil, name: userName, teamName: userTeamName),
                                                             bold: true, size: profileCell.textLabel?.font.pointSize ?? 10,
                                                             teamNameLength: userTeamName?.count)
            profileCell.setLabelText(text: text, detailText: userBio)
            profileCell.setImage(imageURL)
            
            return profileCell
        case 1:
            guard doneRequest else { return LoadingCell() }
            guard requestSuccessful else { return UITableViewCell().setupDisabled(k.Message.errorLoadingProfile) }
            guard !tournaments.isEmpty else { return UITableViewCell().setupDisabled(k.Message.noProfileTournaments) }
            guard let tournament = tournaments[safe: indexPath.row] else { return UITableViewCell() }
            
            let cell = TournamentListCell()

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
            ImageService.getImage(imageUrl: tournament.logoUrl, cache: .profileTournaments, newSize: newSize) { image in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    if cell.tag == indexPath.row {
                        cell.imageView?.image = image
                    }
                }
            }
            return cell
        default: break
        }
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        guard let tournament = tournaments[safe: indexPath.row] else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        navigationController?.pushViewController(TournamentVC(tournament, cacheForLogo: .profileTournaments), animated: true)
    }
}
