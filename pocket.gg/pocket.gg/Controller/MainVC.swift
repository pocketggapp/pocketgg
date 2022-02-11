//
//  MainVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-01-31.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit

enum SectionType {
    case pinned
    case featured
    case upcoming
    case other
}

final class MainVC: UITableViewController {
    
    var tournaments: [[Tournament]]
    var enabledSections: [Int]
    var preferredGames: [VideoGame]
    var doneRequest: [Bool]
    var requestSuccessful: [Bool]
    let numTournamentsToLoad: Int
    
    var showPinned: Bool { enabledSections.contains(-1) }
    var numSections: Int { enabledSections.count }
    var countryCode: String
    var addrState: String
    
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
        enabledSections = MainVCDataService.getEnabledSections()
        
        if UserDefaults.standard.bool(forKey: k.UserDefaults.useSpecificCountry),
           let country = UserDefaults.standard.string(forKey: k.UserDefaults.selectedCountry), !country.isEmpty,
           let code = country.components(separatedBy: ["(", ")"])[safe: 1] {
            countryCode = code
        } else {
            countryCode = ""
        }
        if UserDefaults.standard.bool(forKey: k.UserDefaults.useSpecificState),
           let state = UserDefaults.standard.string(forKey: k.UserDefaults.selectedState), !state.isEmpty,
           let code = state.components(separatedBy: ["(", ")"])[safe: 1] {
            addrState = code
        } else {
            addrState = ""
        }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editSectionOrder))
        tableView.register(ScrollableRowCell.self, forCellReuseIdentifier: k.Identifiers.tournamentsRowCell)
        tableView.separatorColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPinnedTournaments),
                                               name: Notification.Name(k.Notification.tournamentPinToggled), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleTournamentsReload),
                                               name: Notification.Name(k.Notification.settingsChanged), object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        preferredGames = MainVCDataService.getEnabledGames()
        doneRequest = [Bool](repeating: false, count: numSections)
        requestSuccessful = [Bool](repeating: true, count: numSections)
        tournaments = [[Tournament]](repeating: [], count: numSections)
        
        getTournaments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ImageService.clearCache(.viewAllTournaments)
        
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
        enabledSections = MainVCDataService.getEnabledSections()
        
        if UserDefaults.standard.bool(forKey: k.UserDefaults.useSpecificCountry),
           let country = UserDefaults.standard.string(forKey: k.UserDefaults.selectedCountry), !country.isEmpty,
           let code = country.components(separatedBy: ["(", ")"])[safe: 1] {
            countryCode = code
        } else {
            countryCode = ""
        }
        if UserDefaults.standard.bool(forKey: k.UserDefaults.useSpecificState),
           let state = UserDefaults.standard.string(forKey: k.UserDefaults.selectedState), !state.isEmpty,
           let code = state.components(separatedBy: ["(", ")"])[safe: 1] {
            addrState = code
        } else {
            addrState = ""
        }
        
        preferredGames = MainVCDataService.getEnabledGames()
        doneRequest = [Bool](repeating: false, count: numSections)
        requestSuccessful = [Bool](repeating: true, count: numSections)
        tournaments = [[Tournament]](repeating: [], count: numSections)
        tableView.reloadData()
        getTournaments()
    }
    
    private func getTournaments() {
        let dispatchGroup = DispatchGroup()
        
        for _ in 0..<numSections {
            dispatchGroup.enter()
        }
        for i in 0..<numSections {
            switch sectionTypeForIndex(i) {
            case .pinned: getPinnedTournaments(dispatchGroup, i)
            case .featured:
                getFeaturedTournaments(dispatchGroup, i)
            default:
                guard !preferredGames.isEmpty else {
                    doneRequest[i] = true
                    requestSuccessful[i] = true
                    tableView.reloadSections([i], with: .automatic)
                    dispatchGroup.leave()
                    continue
                }
                let gameIDs = sectionTypeForIndex(i) == .upcoming ? preferredGames.map { $0.id } : [enabledSections[i]]
                let info = GetTournamentsByVideogamesInfo(perPage: numTournamentsToLoad, pageNum: 1,
                                                          gameIDs: gameIDs,
                                                          // TODO: maybe leave this out completely? check how it impacts results
                                                          featured: false, upcoming: true,
                                                          countryCode: countryCode, addrState: addrState)
                TournamentInfoService.getTournamentsByVideogames(info) { [weak self] tournaments in
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
        }
        
        // Hide the refresh control once all the requests have finished
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.refreshControl?.endRefreshing()
            
            if self?.requestSuccessful.allSatisfy({ !$0 }) ?? false {
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
    
    private func getPinnedTournaments(_ dispatchGroup: DispatchGroup?, _ i: Int) {
        let pinnedTournamentIDs = MainVCDataService.getPinnedTournamentIDs()
        guard !pinnedTournamentIDs.isEmpty else {
            doneRequest[i] = true
            requestSuccessful[i] = true
            dispatchGroup?.leave()
            return
        }
        var requestSuccessfulPinned = [Bool](repeating: true, count: pinnedTournamentIDs.count)
        var returnedTournaments = [Tournament]()
        
        let pinnedTournamentDispatchGroup = DispatchGroup()
        for _ in 0..<pinnedTournamentIDs.count {
            pinnedTournamentDispatchGroup.enter()
        }
        for (j, id) in pinnedTournamentIDs.enumerated() {
            TournamentInfoService.getTournamentByID(id: id) { tournament in
                guard let tournament = tournament else {
                    requestSuccessfulPinned[j] = false
                    pinnedTournamentDispatchGroup.leave()
                    return
                }
                returnedTournaments.append(tournament)
                
                requestSuccessfulPinned[j] = true
                pinnedTournamentDispatchGroup.leave()
            }
        }
        
        pinnedTournamentDispatchGroup.notify(queue: .main) { [weak self] in
            for id in pinnedTournamentIDs {
                let tournament = returnedTournaments.first { $0.id ?? -1 == id }
                self?.tournaments[i].append(tournament ?? Tournament(id: nil, name: "\(id)", date: nil, logoUrl: nil, isOnline: nil, headerImage: nil))
            }
            self?.doneRequest[i] = true
            // Only consider the overall request unsuccessful if all of the individual requests were unsuccessful
            self?.requestSuccessful[i] = !requestSuccessfulPinned.allSatisfy { !$0 }
            self?.tableView.reloadSections([i], with: .automatic)
            dispatchGroup?.leave()
        }
    }
    
    private func getFeaturedTournaments(_ dispatchGroup: DispatchGroup, _ i: Int) {
        guard !preferredGames.isEmpty else {
            doneRequest[i] = true
            requestSuccessful[i] = true
            tableView.reloadSections([i], with: .automatic)
            dispatchGroup.leave()
            return
        }
        
        let gameIDs = preferredGames.map { $0.id }
        TournamentInfoService.getFeaturedTournaments(perPage: numTournamentsToLoad, pageNum: 1,
                                                     gameIDs: gameIDs) { [weak self] tournaments in
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
    
    @objc private func reloadPinnedTournaments() {
        guard let index = enabledSections.firstIndex(of: -1) else { return }
        doneRequest[index] = false
        requestSuccessful[index] = true
        tournaments[index].removeAll()
        tableView.reloadSections([index], with: .automatic)
        
        getPinnedTournaments(nil, index)
    }
    
    @objc private func scheduleTournamentsReload() {
        shouldReloadTournaments = true
    }
    
    @objc private func editSectionOrder() {
        let vc = EditMainVC(enabledSections)
        vc.applyChanges = { [weak self] in
            self?.reloadTournamentList()
        }
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc private func editPinnedTournaments(sender: UIButton) {
        let vc = EditPinnedTournamentsVC(tournaments[sender.tag])
        vc.applyChanges = { [weak self] in
            self?.tournaments[sender.tag] = $0
            self?.tableView.reloadSections([sender.tag], with: .automatic)
        }
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    // MARK: - Private Helpers
    
    private func sectionTypeForIndex(_ index: Int) -> SectionType {
        guard index < enabledSections.count else { return .other }
        switch enabledSections[index] {
        case -1: return .pinned
        case -2: return .featured
        case -3: return .upcoming
        default: return .other
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func sectionHeaderTitle(for section: Int) -> String? {
        switch sectionTypeForIndex(section) {
        case .pinned: return "Pinned Tournaments"
        case .featured: return "Featured Tournaments"
        case .upcoming: return "Upcoming Tournaments"
        default: return preferredGames.first { $0.id == enabledSections[section] }?.name ?? "Unknown Game"
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let textLabel = UILabel()
        textLabel.text = sectionHeaderTitle(for: section)
        textLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        headerView.addSubview(textLabel)
        textLabel.setEdgeConstraints(top: headerView.topAnchor, bottom: headerView.bottomAnchor, leading: headerView.leadingAnchor,
                                     padding: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 0))
        
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(button)
        button.setEdgeConstraints(top: headerView.topAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor,
                                  padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 16))
        
        // If the pinned tournaments sections is enabled, show the "Edit" button to allow for rearranging of the pinned tournaments
        if sectionTypeForIndex(section) == .pinned, !tournaments[section].isEmpty {
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            button.addTarget(self, action: #selector(editPinnedTournaments(sender:)), for: .touchUpInside)
            button.tag = section
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
        guard doneRequest[indexPath.section] else { return LoadingCell(color: .systemGroupedBackground) }
        guard requestSuccessful[indexPath.section] else {
            let cell = UITableViewCell().setupDisabled(k.Message.errorLoadingTournaments)
            cell.backgroundColor = .systemGroupedBackground
            return cell
        }
        if sectionTypeForIndex(indexPath.section) != .pinned {
            guard !preferredGames.isEmpty else {
                let cell = UITableViewCell().setupDisabled(k.Message.noPreferredGames)
                cell.backgroundColor = .systemGroupedBackground
                return cell
            }
        }
        guard !tournaments[indexPath.section].isEmpty else {
            let message = sectionTypeForIndex(indexPath.section) == .pinned ? k.Message.noPinnedTournaments : k.Message.noTournaments
            let cell = UITableViewCell().setupDisabled(message)
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
        if sectionTypeForIndex(indexPath.section) == .pinned {
            guard doneRequest[indexPath.section], !tournaments[indexPath.section].isEmpty else {
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
        guard doneRequest[collectionView.tag], requestSuccessful[collectionView.tag] else { return 0 }
        if sectionTypeForIndex(collectionView.tag) == .pinned { return tournaments[collectionView.tag].count }
        // If more than 10 tournaments were returned, only show the first 10 and show a "View All" button in the header view
        return tournaments[collectionView.tag].count > 10 ? 10 : tournaments[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: k.Identifiers.tournamentCell, for: indexPath) as? ScrollableRowItemCell {
            
            let tournament = tournaments[safe: collectionView.tag]?[safe: indexPath.row]
            
            cell.imageView.image = nil // change to placeholder
            cell.setLabelsStyle()
            var detailText = tournament?.date ?? ""
            detailText += tournament?.isOnline ?? false ? "\nOnline" : ""
            cell.updateView(text: tournament?.name, imageURL: tournament?.logoUrl, detailText: detailText)
            
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
        guard let tournament = tournaments[safe: collectionView.tag]?[safe: indexPath.row] else { return }
        navigationController?.pushViewController(TournamentVC(tournament, cacheForLogo: .viewAllTournaments), animated: true)
    }
    
    @objc private func viewAllTournaments(sender: UIButton) {
        let section = sender.tag
        let preferredGameIDs = preferredGames.map { $0.id }
        let isFeaturedOrUpcoming = sectionTypeForIndex(section) == .featured || sectionTypeForIndex(section) == .upcoming
        let gameIDs = isFeaturedOrUpcoming ? preferredGameIDs : [enabledSections[section]]
        
        navigationController?.pushViewController(ViewAllTournamentsVC(tournaments[section], perPage: numTournamentsToLoad,
                                                                      featured: section == 0, gameIDs: gameIDs,
                                                                      title: sectionHeaderTitle(for: section),
                                                                      countryCode: countryCode, addrState: addrState), animated: true)
    }
}
