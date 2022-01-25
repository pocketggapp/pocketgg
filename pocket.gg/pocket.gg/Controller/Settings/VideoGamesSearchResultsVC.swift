//
//  VideoGamesSearchResultsVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-05-26.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class VideoGamesSearchResultsVC: UITableViewController {
    
    var searchTerm: String?
    var searchResults: [VideoGame]
    var enabledGames: [VideoGame]
    var enabledGameIDs: Set<Int>
    
    var doneLoading: Bool
    
    var enabledGamesChanged: Bool
    var reloadEnabledGames: (() -> Void)?
    
    /// Determines whether the VC can notify MainVC that a setting was changed, and that the tournaments should be reloaded
    /// - Will be initialized to true whenever the view appears
    /// - When a setting is changed, the notification is sent, this is set to false, and is not set to true again until the view disappears
    var canSendNotification: Bool
    
    // MARK: - Initialization
    
    init(searchTerm: String?, enabledGames: [VideoGame]) {
        self.searchTerm = searchTerm
        self.enabledGames = enabledGames
        searchResults = []
        enabledGameIDs = enabledGames.reduce(into: Set<Int>()) { $0.insert($1.id) }
        doneLoading = false
        enabledGamesChanged = false
        canSendNotification = true
        super.init(style: .insetGrouped)
        title = searchTerm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: k.Identifiers.videoGameCell)
        getVideoGamesForSearch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Save the list of enabled video games
        MainVCDataService.updateEnabledGames(enabledGames)
        canSendNotification = true
        if let reloadEnabledGames = reloadEnabledGames, enabledGamesChanged {
            reloadEnabledGames()
            enabledGamesChanged = false
        }
    }
    
    private func getVideoGamesForSearch() {
        do {
            searchResults = try VideoGameDatabase.getVideoGamesForSearch(searchTerm ?? "")
        } catch {
            searchResults = []
            print(error)
            // TODO: Show error
        }
        doneLoading = true
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard doneLoading else { return 1 }
        return searchResults.isEmpty ? 1 : searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard doneLoading else { return LoadingCell() }
        guard !searchResults.isEmpty else { return UITableViewCell().setupDisabled("No search results") }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.videoGameCell, for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].name
        cell.accessoryType = enabledGameIDs.contains(searchResults[indexPath.row].id) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // If at least 1 game was selected/deselected, reload the previous screen's table view upon exiting this screen
        enabledGamesChanged = true
        requestTournamentsReload()
        
        let selectedID = searchResults[indexPath.row].id
        // If the game was already enabled, disable it
        if enabledGameIDs.contains(selectedID) {
            enabledGameIDs.remove(selectedID)
            if let index = enabledGames.firstIndex(where: { $0.id == selectedID }) {
                enabledGames.remove(at: index)
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        // Else, enable the game
        } else {
            enabledGameIDs.insert(selectedID)
            enabledGames.append(searchResults[indexPath.row])
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    // MARK: - Actions
    
    private func requestTournamentsReload() {
        if canSendNotification {
            NotificationCenter.default.post(name: Notification.Name(k.Notification.settingsChanged), object: nil)
            canSendNotification = false
        }
    }
}
