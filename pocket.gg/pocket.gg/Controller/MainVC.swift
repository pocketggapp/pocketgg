//
//  MainVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-01-31.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

final class MainVC: UITableViewController {
    
    /// - If showPinned == true, index 0 of tournaments will be empty (the pinned tournaments are retrieved from PinnedTournamentsService)
    var tournaments: [[Tournament]]
    var preferredGames: [VideoGame]
    var doneRequest: [Bool]
    var requestSuccessful: [Bool]
    let numTournamentsToLoad: Int
    
    var showPinned: Bool
    var showFeatured: Bool
    var showUpcoming: Bool
    var numTopSections: Int {
        return (showPinned ? 1 : 0) + (showFeatured ? 1 : 0) + (showUpcoming ? 1 : 0)
    }
    var numSections: Int {
        return numTopSections + preferredGames.count
    }
    
    /// Determines whether the VC should reload the list of tournaments to reflect a settings change
    /// - Initialized to false
    /// - When a setting is changed, the notification is sent, and this variable is set to true
    /// - Once the view appears again, if this variable is true, the list of tournaments is reloaded and this variable is set back to false
    var shouldReloadTournaments: Bool
    
    var lastRefreshTime: Date?
    
    // MARK: - Initialization
    
    override init(style: UITableView.Style) {
        tournaments = []
        preferredGames = []
        doneRequest = []
        requestSuccessful = []
        let longEdgeLength = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        numTournamentsToLoad = 2 * Int(longEdgeLength / k.Sizes.tournamentListCellHeight)
        showPinned = UserDefaults.standard.bool(forKey: k.UserDefaults.showPinnedTournaments)
        showFeatured = UserDefaults.standard.bool(forKey: k.UserDefaults.featuredTournaments)
        showUpcoming = UserDefaults.standard.bool(forKey: k.UserDefaults.upcomingTournaments)
        shouldReloadTournaments = false
        
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tournaments"
        tableView.register(ScrollableRowCell.self, forCellReuseIdentifier: k.Identifiers.tournamentsRowCell)
        tableView.separatorColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPinnedTournaments),
                                               name: Notification.Name(k.Notification.tournamentPinToggled), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleTournamentsReload),
                                               name: Notification.Name(k.Notification.settingsChanged), object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        preferredGames = PreferredGamesService.getEnabledGames()
        doneRequest = [Bool](repeating: false, count: numSections)
        requestSuccessful = [Bool](repeating: true, count: numSections)
        tournaments = [[Tournament]](repeating: [], count: numSections)
        
        getTournaments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ImageCacheService.clearCache(.viewAllTournaments)
        
        if shouldReloadTournaments {
            shouldReloadTournaments = false
            reloadTournamentList()
        }
        
        if !UserDefaults.standard.bool(forKey: k.UserDefaults.returningUser) {
            UserDefaults.standard.set(true, forKey: k.UserDefaults.returningUser)
            let alert = UIAlertController(title: k.UserDefaults.returningUserTitle, message: k.UserDefaults.returningUserMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
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
        reloadTournamentList()
    }
    
    @objc private func reloadTournamentList() {
        showPinned = UserDefaults.standard.bool(forKey: k.UserDefaults.showPinnedTournaments)
        showFeatured = UserDefaults.standard.bool(forKey: k.UserDefaults.featuredTournaments)
        showUpcoming = UserDefaults.standard.bool(forKey: k.UserDefaults.upcomingTournaments)
        
        preferredGames = PreferredGamesService.getEnabledGames()
        doneRequest = [Bool](repeating: false, count: numSections)
        requestSuccessful = [Bool](repeating: true, count: numSections)
        tournaments = [[Tournament]](repeating: [], count: numSections)
        tableView.reloadData()
        getTournaments()
    }
    
    private func getTournaments() {
        guard !preferredGames.isEmpty else {
            doneRequest = [Bool](repeating: true, count: numSections)
            requestSuccessful = [Bool](repeating: true, count: numSections)
            refreshControl?.endRefreshing()
            tableView.reloadData()
            return
        }
        
        let dispatchGroup = DispatchGroup()
        let gameIDs = preferredGames.map { $0.id }
        
        let startSectionIndex = showPinned ? 1 : 0
        let topSectionsEndIndex = startSectionIndex + (showFeatured ? 1 : 0) + (showUpcoming ? 1 : 0)
        
        for _ in startSectionIndex..<numSections {
            dispatchGroup.enter()
        }
        for i in startSectionIndex..<numSections {
            let featured = showFeatured && i == startSectionIndex
            let gameIDs = i < topSectionsEndIndex ? gameIDs : [gameIDs[i - topSectionsEndIndex]]
            NetworkService.getTournamentsByVideogames(perPage: numTournamentsToLoad,
                                                      pageNum: 1,
                                                      featured: featured,
                                                      upcoming: true,
                                                      gameIDs: gameIDs) { [weak self] (tournaments) in
                guard let tournaments = tournaments else {
                    self?.doneRequest[i] = true
                    self?.requestSuccessful[i] = false
                    self?.tableView.reloadSections([i], with: .automatic)
                    dispatchGroup.leave()
                    return
                }
                self?.tournaments[i] = tournaments
                
                self?.doneRequest[i] = true
                self?.requestSuccessful[i] = true
                self?.tableView.reloadSections([i], with: .automatic)
                dispatchGroup.leave()
            }
        }
        
        // Hide the refresh control once all the requests have finished
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.refreshControl?.endRefreshing()
            
            var requestStatuses = self?.requestSuccessful
            if let showPinned = self?.showPinned, showPinned {
                requestStatuses?.removeFirst()
            }
            if requestStatuses?.allSatisfy({ !$0 }) ?? false {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                
                let message: String
                if let currentDate = dateFormatter.date(from: DateFormatter.shared.dateFromTimestamp("\(Int(Date().timeIntervalSince1970))")),
                   let authTokenDate = dateFormatter.date(from: UserDefaults.standard.string(forKey: k.UserDefaults.authTokenDate) ?? ""),
                   let numDaysDifference = Calendar.current.dateComponents([.day], from: authTokenDate, to: currentDate).day,
                   numDaysDifference >= 365 {
                    message = """
                    It looks like your auth token may have expired. To restore this app's functionality, clear the current auth token by clicking \
                    Settings → Auth Token → Clear Auth Token. You can then obtain a new auth token from smash.gg and paste it in this app's \
                    Auth Token field.
                    """
                } else {
                    message = "There was an error fetching tournaments, try checking your internet connection."
                }
                let alert = UIAlertController(title: k.Error.title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc private func reloadPinnedTournaments() {
        tableView.reloadSections([0], with: .automatic)
    }
    
    @objc private func scheduleTournamentsReload() {
        shouldReloadTournaments = true
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func sectionHeaderTitle(for section: Int) -> String? {
        switch section {
        case 0:
            if showPinned { return "Pinned Tournaments" }
            if showFeatured { return "Featured Tournaments" }
            if showUpcoming { return "Upcoming Tournaments" }
            return preferredGames[section].name
        case 1:
            if showPinned && showFeatured { return "Featured Tournaments" }
            if (showPinned || showFeatured) && showUpcoming { return "Upcoming Tournaments" }
            guard section - numTopSections < preferredGames.count else { return nil }
            return preferredGames[section - numTopSections].name
        case 2:
            if showPinned && showFeatured && showUpcoming { return "Upcoming Tournaments" }
            guard section - numTopSections < preferredGames.count else { return nil }
            return preferredGames[section - numTopSections].name
        default:
            guard section - numTopSections < preferredGames.count else { return nil }
            return preferredGames[section - numTopSections].name
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let textLabel = UILabel()
        textLabel.text = sectionHeaderTitle(for: section)
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
        
        // If the pinned tournaments sections is enabled, show the "Edit" button to allow for rearranging of the pinned tournaments
        if section == 0, showPinned, PinnedTournamentsService.numPinnedTournaments != 0 {
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            button.addTarget(self, action: #selector(editPinnedTournaments), for: .touchUpInside)
            button.leadingAnchor.constraint(greaterThanOrEqualTo: textLabel.trailingAnchor, constant: 5).isActive = true
        }
        // If there are more than 10 tournaments in a section, show the "View All" button
        // To make the vertical spacing consistent, the "View All" button is always added (just not visible when there are 10 or less tournaments)
        else if tournaments[section].count > 10 {
            button.setTitle("View All", for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            button.addTarget(self, action: #selector(viewAllTournaments(sender:)), for: .touchUpInside)
            button.tag = section
            button.leadingAnchor.constraint(greaterThanOrEqualTo: textLabel.trailingAnchor, constant: 5).isActive = true
        } else {
            textLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Pinned Tournaments Section
        if showPinned, indexPath.section == 0 {
            guard PinnedTournamentsService.numPinnedTournaments != 0 else {
                let cell = UITableViewCell().setupDisabled(k.Message.noPinnedTournaments)
                cell.textLabel?.numberOfLines = 0
                cell.backgroundColor = .systemGroupedBackground
                return cell
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.tournamentsRowCell, for: indexPath) as? ScrollableRowCell {
                return cell
            }
            return UITableViewCell()
        }
        
        guard doneRequest[indexPath.section] else { return LoadingCell(color: .systemGroupedBackground) }
        guard requestSuccessful[indexPath.section] else {
            let cell = UITableViewCell().setupDisabled(k.Message.errorLoadingTournaments)
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .systemGroupedBackground
            return cell
        }
        guard !preferredGames.isEmpty else {
            let cell = UITableViewCell().setupDisabled(k.Message.noPreferredGames)
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .systemGroupedBackground
            return cell
        }
        guard !tournaments[indexPath.section].isEmpty else {
            let cell = UITableViewCell().setupDisabled(k.Message.noTournaments)
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .systemGroupedBackground
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.tournamentsRowCell, for: indexPath) as? ScrollableRowCell {
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ScrollableRowCell else { return }
        cell.setCollectionViewProperties(self, forSection: indexPath.section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showPinned, indexPath.section == 0 {
            guard PinnedTournamentsService.numPinnedTournaments != 0 else {
                return UITableView.automaticDimension
            }
            return k.Sizes.tournamentCellHeight
        }
        guard doneRequest[indexPath.section], !preferredGames.isEmpty, !tournaments[indexPath.section].isEmpty else {
            return UITableView.automaticDimension
        }
        return k.Sizes.tournamentCellHeight
    }
}

// MARK: - Collection View Data Source & Delegate

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showPinned, collectionView.tag == 0 { return PinnedTournamentsService.numPinnedTournaments }
        
        guard doneRequest[collectionView.tag], requestSuccessful[collectionView.tag] else { return 0 }
        // If more than 10 tournaments were returned, only show the first 10 and show a "View All" button in the header view
        return tournaments[collectionView.tag].count > 10 ? 10 : tournaments[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: k.Identifiers.tournamentCell, for: indexPath) as? ScrollableRowItemCell {
            
            let tournamentToShow: Tournament
            if showPinned, collectionView.tag == 0 {
                if let tournament = PinnedTournamentsService.pinnedTournament(at: indexPath.row) {
                    tournamentToShow = tournament
                } else {
                    return cell
                }
            } else {
                if let tournament = tournaments[safe: collectionView.tag]?[safe: indexPath.row] {
                    tournamentToShow = tournament
                } else {
                    return cell
                }
            }
            
            cell.imageView.image = nil
            cell.setLabelsStyle()
            var detailText = tournamentToShow.date ?? ""
            detailText += tournamentToShow.isOnline ?? true ? "\nOnline" : ""
            cell.updateView(text: tournamentToShow.name, imageURL: tournamentToShow.logoUrl, detailText: detailText)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: k.Sizes.tournamentCellWidth, height: k.Sizes.tournamentCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showPinned, collectionView.tag == 0 {
            guard let tournament = PinnedTournamentsService.pinnedTournament(at: indexPath.row) else { return }
            navigationController?.pushViewController(TournamentVC(tournament, cacheForLogo: .viewAllTournaments), animated: true)
            return
        }
        
        guard let tournament = tournaments[safe: collectionView.tag]?[safe: indexPath.row] else { return }
        navigationController?.pushViewController(TournamentVC(tournament, cacheForLogo: .viewAllTournaments), animated: true)
    }
    
    @objc private func viewAllTournaments(sender: UIButton) {
        let section = sender.tag
        let gameIDs = section < numTopSections ? preferredGames.map { $0.id } : [preferredGames.map({ $0.id })[section - numTopSections]]
        let info = GetTournamentsByVideogamesInfo(perPage: numTournamentsToLoad,
                                                  featured: section == 0,
                                                  gameIDs: gameIDs)
        navigationController?.pushViewController(ViewAllTournamentsVC(tournaments[section],
                                                                      info: info,
                                                                      title: sectionHeaderTitle(for: section)), animated: true)
    }
    
    @objc private func editPinnedTournaments() {
        let editPinnedTournamentsVC = EditPinnedTournamentsVC()
        present(UINavigationController(rootViewController: editPinnedTournamentsVC), animated: true, completion: nil)
    }
}
