//
//  VideoGamesVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2020-02-12.
//  Copyright © 2020 Gabriel Siu. All rights reserved.
//

import UIKit
import MessageUI

final class VideoGamesVC: UITableViewController {
    
    var headerView: UIView
    let searchBar: UISearchBar
    var enabledGames: [VideoGame]
    
    /// Determines whether the VC can notify MainVC that a setting was changed, and that the tournaments should be reloaded
    /// - Will be initialized to true whenever the view appears
    /// - When a setting is changed, the notification is sent, this is set to false, and is not set to true again until the view disappears
    var canSendNotification: Bool
    
    // MARK: - Initialization
    
    init() {
        // Load the list of enabled video games
        enabledGames = PreferredGamesService.getEnabledGames()
        headerView = UIView(frame: .zero)
        searchBar = UISearchBar(frame: .zero)
        canSendNotification = true
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Video Game Selection"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: k.Identifiers.videoGameCell)
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelectionDuringEditing = true
        navigationItem.rightBarButtonItem = enabledGames.isEmpty ? nil : editButtonItem
        setupHeaderView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canSendNotification = true
    }
    
    private func setupHeaderView() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Video Games"
        searchBar.searchBarStyle = .minimal
        
        let textLabel = UILabel(frame: .zero)
        textLabel.text = "Enabled Games"
        textLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        headerView.addSubview(searchBar)
        headerView.addSubview(textLabel)
        
        searchBar.setEdgeConstraints(top: headerView.topAnchor,
                                     bottom: textLabel.topAnchor,
                                     leading: headerView.leadingAnchor,
                                     trailing: headerView.trailingAnchor)
        textLabel.setEdgeConstraints(top: searchBar.bottomAnchor,
                                     bottom: headerView.bottomAnchor,
                                     leading: headerView.leadingAnchor,
                                     trailing: headerView.trailingAnchor,
                                     padding: UIEdgeInsets(top: 0, left: 16, bottom: 5, right: 0))
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 { return 1 }
        return enabledGames.isEmpty ? 1 : enabledGames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            return UITableViewCell().setupActive(textColor: .systemRed, text: "Can't find the video game that you're looking for?")
        }
        
        guard !enabledGames.isEmpty else { return UITableViewCell().setupDisabled("No enabled games") }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.videoGameCell, for: indexPath)
        cell.textLabel?.text = enabledGames[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        return headerView
    }
    
    // TODO: Figure out why footer is slidable when only 1 game is added
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        return """
        Use the search bar to find video games that you're interested in. Tournaments that feature at least 1 of the games added here \
        will show up on the main screen.
        """
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 0 else { return false }
        return !enabledGames.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 0 else { return false }
        return !enabledGames.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedVideoGame = enabledGames.remove(at: sourceIndexPath.row)
        enabledGames.insert(movedVideoGame, at: destinationIndexPath.row)
        PreferredGamesService.updateEnabledGames(enabledGames)
        requestTournamentsReload()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            enabledGames.remove(at: indexPath.row)
            tableView.reloadData()
            if enabledGames.isEmpty {
                navigationItem.rightBarButtonItem = nil
            }
            PreferredGamesService.updateEnabledGames(enabledGames)
            requestTournamentsReload()
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "", message: k.Alert.videoGameSelection, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Send video game update request", style: .default, handler: { [weak self] _ in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["pocketggapp@gmail.com"])
                mail.setSubject("pocket.gg Video Game Update Request")
                let message = """
                Please enter the required info between the lines:
                ---------------------------------------
                
                Name of video game (Required):
                
                Name and/or URL of tournament on smash.gg that features the missing video game (Required):

                ---------------------------------------
                """
                mail.setMessageBody(message, isHTML: false)
                self?.present(mail, animated: true)
            } else {
                let message = """
                Please send an email to pocketggapp@gmail.com and include the following details:
                Name of the video game
                Name and/or URL of tournament on smash.gg that features the missing video game
                """
                let alert = UIAlertController(title: "Video Game Update Request", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    private func requestTournamentsReload() {
        if canSendNotification {
            NotificationCenter.default.post(name: Notification.Name(k.Notification.settingsChanged), object: nil)
            canSendNotification = false
        }
    }
}

// MARK: - Search Bar Delegate

extension VideoGamesVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let text = searchBar.text, !text.isEmpty else { return }
        let videoGamesSearchResultsVC = VideoGamesSearchResultsVC(searchTerm: text, enabledGames: enabledGames)
        videoGamesSearchResultsVC.reloadEnabledGames = { [weak self] in
            // If the list of enabled games was changed in VideoGamesSearchResultsVC, reload the table view
            self?.enabledGames = PreferredGamesService.getEnabledGames()
            self?.tableView.reloadData()
            if let noEnabledGames = self?.enabledGames.isEmpty, noEnabledGames {
                self?.navigationItem.rightBarButtonItem = nil
            } else {
                self?.navigationItem.rightBarButtonItem = self?.editButtonItem
            }
        }
        navigationController?.pushViewController(videoGamesSearchResultsVC, animated: true)
    }
}

extension VideoGamesVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
