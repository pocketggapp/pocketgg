//
//  FollowingVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-26.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class FollowingVC: UITableViewController {

  /// Determines whether the VC should reload the list of TOs followed to reflect a change in TOs followed
  /// - Initialized to false
  /// - When a TO is followed, the notification is sent, and this variable is set to true
  /// - Once the view appears again, if this variable is true, the list of TOs is reloaded and this variable is set back to false
  private var shouldReloadTOs: Bool

  init() {
    shouldReloadTOs = false
    super.init(style: .insetGrouped)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Following"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: k.Identifiers.tournamentOrganizerCell)
    tableView.allowsSelectionDuringEditing = true
    NotificationCenter.default.addObserver(self, selector: #selector(scheduleTOsReload),
                                           name: Notification.Name(k.Notification.followedTournamentOrganizer), object: nil)
    navigationItem.rightBarButtonItem = TOFollowedService.noTOsFollowed ? nil : editButtonItem
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if shouldReloadTOs {
      shouldReloadTOs = false
      tableView.reloadData()
      navigationItem.rightBarButtonItem = TOFollowedService.noTOsFollowed ? nil : editButtonItem
    }
  }

  // MARK: Actions

  @objc private func scheduleTOsReload() {
    shouldReloadTOs = true
  }

  // MARK: Table View Data Source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TOFollowedService.noTOsFollowed ? 1 : TOFollowedService.numTOsFollowed
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard !TOFollowedService.noTOsFollowed else { return UITableViewCell().setupDisabled("No tournament organizers followed") }

    let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.tournamentOrganizerCell, for: indexPath)

    guard let TO = TOFollowedService.followedTO(at: indexPath.row) else { return cell }
    let attributedText: NSAttributedString
    if TO.customPrefix != nil || TO.customName != nil {
      attributedText = SetUtilities.getAttributedEntrantText(
        Entrant(id: nil, name: TO.customName, teamName: TO.customPrefix),
        bold: false, size: cell.textLabel?.font.pointSize ?? 10,
        teamNameLength: TO.customPrefix?.count
      )
    } else {
      attributedText = SetUtilities.getAttributedEntrantText(
        Entrant(id: nil, name: TO.name, teamName: TO.prefix),
        bold: false, size: cell.textLabel?.font.pointSize ?? 10,
        teamNameLength: TO.prefix?.count
      )
    }
    cell.textLabel?.attributedText = attributedText
    cell.textLabel?.numberOfLines = 0
    cell.accessoryType = .disclosureIndicator

    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return !TOFollowedService.noTOsFollowed
  }

  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return !TOFollowedService.noTOsFollowed
  }

  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    TOFollowedService.rearrangeFollowedTOs(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      TOFollowedService.removeTO(at: indexPath.row)
      tableView.reloadData()
      if TOFollowedService.noTOsFollowed {
        navigationItem.rightBarButtonItem = nil
      }
    }
  }

  // MARK: Table View Delegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let TO = TOFollowedService.followedTO(at: indexPath.row) else {
      tableView.deselectRow(at: indexPath, animated: true)
      return
    }
    if tableView.isEditing {
      tableView.deselectRow(at: indexPath, animated: true)
      let alert = UIAlertController(title: "Edit Name and Prefix", message: nil, preferredStyle: .alert)
      alert.addTextField { textField in
        textField.clearButtonMode = .whileEditing
        textField.placeholder = TO.prefix
        if let customPrefix = TO.customPrefix, !customPrefix.isEmpty {
          textField.text = customPrefix
        }
      }
      alert.addTextField { textField in
        textField.clearButtonMode = .whileEditing
        textField.placeholder = TO.name
        if let customName = TO.customName, !customName.isEmpty {
          textField.text = customName
        }
      }
      alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
        let customName = alert.textFields?[safe: 1]?.text
        let customPrefix = alert.textFields?[safe: 0]?.text
        TOFollowedService.updateTO(at: indexPath.row, customName: customName, customPrefix: customPrefix)
        tableView.reloadData()
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      present(alert, animated: true)
    } else {
      if TO.customPrefix != nil || TO.customName != nil {
        navigationController?.pushViewController(TournamentsByTOVC(id: TO.id, name: TO.customName, prefix: TO.customPrefix), animated: true)
      } else {
        navigationController?.pushViewController(TournamentsByTOVC(id: TO.id, name: TO.name, prefix: TO.prefix), animated: true)
      }
    }
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if TOFollowedService.noTOsFollowed {
      return """
      To follow a tournament organizer, tap the … icon at the top right of any tournament page, then tap "View more tournaments \
      by this tournament organizer", then tap "Follow".
      """
    } else {
      return """
      You can add a custom name and/or prefix for any tournament organizer by tapping "Edit", then tapping the row you want to edit.
      """
    }
  }

  override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Unfollow"
  }
}
