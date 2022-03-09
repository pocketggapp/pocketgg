//
//  VideoGamesVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-01-30.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import UIKit
import MessageUI

final class VideoGamesVC: UITableViewController {
    
    let searchController: UISearchController
    
    var videoGames = [VideoGame]()
    var filteredVideoGames = [VideoGame]()
    var enabledGames = [VideoGame]()
    var enabledGamesChanged: Bool
    
    var applyChanges: (([VideoGame]) -> Void)?
    
    // MARK: - Initialization
    
    init(_ enabledGames: [VideoGame]) {
        searchController = UISearchController(searchResultsController: nil)
        filteredVideoGames = []
        do {
            videoGames = try VideoGameDatabase.getVideoGames()
        } catch {
            videoGames = []
            // TODO: Show error
        }
        enabledGamesChanged = false
        self.enabledGames = enabledGames
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Video Game Selection"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveChanges))
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.setValue("Done", forKey: "cancelButtonText")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: k.Identifiers.videoGameCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Actions
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveChanges() {
        if enabledGamesChanged {
            if let applyChanges = applyChanges {
                dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    applyChanges(self.enabledGames)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func presentVideoGamesAlert() {
        let alert = UIAlertController(title: "", message: k.Alert.videoGameSelection, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Send video game update request", style: .default, handler: { [weak self] _ in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([k.Mail.address])
                mail.setSubject("pocket.gg Video Game Update Request")
                mail.setMessageBody(k.Mail.videoGameUpdateRequest, isHTML: false)
                self?.present(mail, animated: true)
            } else {
                let alert = UIAlertController(title: "Video Game Update Request", message: k.Mail.videoGameUpdateRequestFallback, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self?.present(alert, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return searchController.isActive ? filteredVideoGames.count : 1
        case 1 : return videoGames.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? "Search Results" : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !searchController.isActive, indexPath.section == 0 {
            return UITableViewCell().setupActive(textColor: .systemRed, text: "Can't find the video game that you're looking for?")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.videoGameCell, for: indexPath)
        let videoGame = searchController.isActive ? filteredVideoGames[indexPath.row] : videoGames[indexPath.row]
        cell.textLabel?.text = videoGame.name
        cell.accessoryType = enabledGames.contains(videoGame) ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !searchController.isActive, indexPath.section == 0 {
            presentVideoGamesAlert()
            return
        }
        
        enabledGamesChanged = true
        
        let selectedGame = searchController.isActive ? filteredVideoGames[indexPath.row] : videoGames[indexPath.row]
        if enabledGames.contains(selectedGame) {
            if let index = enabledGames.firstIndex(where: { $0 == selectedGame }) {
                enabledGames.remove(at: index)
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            enabledGames.append(selectedGame)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
}

extension VideoGamesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredVideoGames.removeAll()
        guard let searchText = searchController.searchBar.text else { return }
        filteredVideoGames = videoGames.filter { $0.name.range(of: searchText, options: [.caseInsensitive]) != nil }
        tableView.reloadData()
    }
}

extension VideoGamesVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
