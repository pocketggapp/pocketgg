//
//  TournamentSearchVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-05-23.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class TournamentSearchVC: UITableViewController {
    
    let searchBar: UISearchBar
    var recentSearches: [String]
    
    let featuredCell: UITableViewCell
    let olderTournamentsFirstCell: UITableViewCell
    let searchUsingEnabledGamesCell: UITableViewCell
    let searchUsingEnabledGamesSwitch: UISwitch
    
    // MARK: - Initialization
    
    init() {
        searchBar = UISearchBar(frame: .zero)
        recentSearches = UserDefaults.standard.array(forKey: k.UserDefaults.recentSearches) as? [String] ?? []
        featuredCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        olderTournamentsFirstCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        searchUsingEnabledGamesCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        searchUsingEnabledGamesSwitch = UISwitch()
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search Tournaments on smash.gg"
        navigationItem.titleView = searchBar
        tableView.keyboardDismissMode = .onDrag
        setupSwitchCells()
    }
    
    private func setupSwitchCells() {
        let featuredSwitch = UISwitch()
        featuredSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.onlySearchFeatured)
        featuredSwitch.addTarget(self, action: #selector(featuredSwitchToggled(_:)), for: .valueChanged)
        featuredCell.accessoryView = featuredSwitch
        featuredCell.selectionStyle = .none
        featuredCell.textLabel?.text = "Featured"
        featuredCell.detailTextLabel?.text = "Only search for tournaments that are featured on smash.gg"
        featuredCell.detailTextLabel?.numberOfLines = 0
        
        let olderTournamentsFirstSwitch = UISwitch()
        olderTournamentsFirstSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.showOlderTournamentsFirst)
        olderTournamentsFirstSwitch.addTarget(self, action: #selector(olderTournamentsFirstSwitchToggled(_:)), for: .valueChanged)
        olderTournamentsFirstCell.accessoryView = olderTournamentsFirstSwitch
        olderTournamentsFirstCell.selectionStyle = .none
        olderTournamentsFirstCell.textLabel?.text = "Older tournaments first"
        olderTournamentsFirstCell.detailTextLabel?.text = "Show older tournaments at the top rather than newer tournaments"
        olderTournamentsFirstCell.detailTextLabel?.numberOfLines = 0
        searchUsingEnabledGamesSwitch.isOn = UserDefaults.standard.bool(forKey: k.UserDefaults.searchUsingEnabledGames)
        searchUsingEnabledGamesSwitch.addTarget(self, action: #selector(searchUsingEnabledGamesSwitchToggled(_:)), for: .valueChanged)
        searchUsingEnabledGamesCell.accessoryView = searchUsingEnabledGamesSwitch
        searchUsingEnabledGamesCell.selectionStyle = .none
        searchUsingEnabledGamesCell.textLabel?.text = "Search using enabled games"
        searchUsingEnabledGamesCell.detailTextLabel?.text = "Only search for tournaments that feature the games enabled in Video Game Selection"
        searchUsingEnabledGamesCell.detailTextLabel?.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImageService.clearCache(.tournamentSearchResults)
    }
    
    // MARK: - Actions
    
    @objc private func featuredSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.onlySearchFeatured)
    }
    
    @objc private func olderTournamentsFirstSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.showOlderTournamentsFirst)
    }
    
    @objc private func searchUsingEnabledGamesSwitchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: k.UserDefaults.searchUsingEnabledGames)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return recentSearches.isEmpty ? 3 : 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return recentSearches.isEmpty ? 1 : recentSearches.count
        case 2, 3: return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return featuredCell
            case 1: return olderTournamentsFirstCell
            case 2: return searchUsingEnabledGamesCell
            default: return UITableViewCell()
            }
        case 1:
            guard !recentSearches.isEmpty else {
                return UITableViewCell().setupDisabled("No recent searches")
            }
            return UITableViewCell().setupActive(textColor: .label, text: recentSearches[indexPath.row])
        case 2:
            if recentSearches.isEmpty { fallthrough }
            let cell = UITableViewCell()
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.text = "Clear recent searches"
            return cell
        case 3:
            return UITableViewCell().setupActive(textColor: .systemRed, text: "Not getting the search results that you're expecting?")
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Search Settings"
        case 1: return "Recent Searches"
        default: return nil
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard let text = recentSearches[safe: indexPath.row] else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            let preferredGameIDs = searchUsingEnabledGamesSwitch.isOn ? MainVCDataService.getEnabledGames().map { $0.id } : []
            navigationController?.pushViewController(TournamentSearchResultsVC(searchTerm: text, preferredGameIDs: preferredGameIDs), animated: true)
        case 2:
            if recentSearches.isEmpty { fallthrough }
            recentSearches.removeAll()
            tableView.reloadData()
            UserDefaults.standard.setValue([], forKey: k.UserDefaults.recentSearches)
        case 3:
            tableView.deselectRow(at: indexPath, animated: true)
            let alert = UIAlertController(title: "", message: k.Alert.searchResults, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - Search Bar Delegate

extension TournamentSearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        let preferredGameIDs = searchUsingEnabledGamesSwitch.isOn ? MainVCDataService.getEnabledGames().map { $0.id } : []
        navigationController?.pushViewController(TournamentSearchResultsVC(searchTerm: text, preferredGameIDs: preferredGameIDs), animated: true)
        
        // If the search term is already present, just move it to the front of the array
        if let index = recentSearches.firstIndex(of: text) {
            recentSearches.remove(at: index)
            recentSearches.insert(text, at: 0)
        } else {
            // Assert a maximum of 10 saved search terms
            if recentSearches.count >= 10 {
                recentSearches.removeLast()
            }
            recentSearches.insert(text, at: 0)
        }
        
        tableView.reloadData()
        UserDefaults.standard.setValue(recentSearches, forKey: k.UserDefaults.recentSearches)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
    }
}
