//
//  EditMainVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-01-21.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import UIKit

final class EditMainVC: UITableViewController {
    
  private var enabledSections: [Int]
  private var disabledSections: [Int]
  private var sectionsEdited: Bool
  private var preferredGames: [VideoGame]
  private var discardedGames: Set<VideoGame>

  var applyChanges: (() -> Void)?

  // MARK: - Initialization

  init(_ enabledSections: [Int]) {
    self.enabledSections = enabledSections
    var missingSections = [Int]()
    if !enabledSections.contains(-1) {
      missingSections.append(-1)
    }
    if !enabledSections.contains(-2) {
      missingSections.append(-2)
    }
    if !enabledSections.contains(-3) {
      missingSections.append(-3)
    }
    disabledSections = missingSections
    sectionsEdited = false
    preferredGames = MainVCDataService.getEnabledGames()
    discardedGames = []
    super.init(style: .insetGrouped)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveChanges))

    tableView.allowsSelectionDuringEditing = true
    setEditing(true, animated: false)
  }

  // MARK: - Actions

  @objc private func dismissVC() {
    dismiss(animated: true, completion: nil)
  }

  @objc private func saveChanges() {
    if sectionsEdited {
      MainVCDataService.updateEnabledGames(preferredGames)
      MainVCDataService.updateEnabledSections(enabledSections)
      if let applyChanges = applyChanges {
        dismiss(animated: true) {
          applyChanges()
        }
      }
    }
    dismiss(animated: true, completion: nil)
  }

  // MARK: - Table View Data Source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return enabledSections.count
    case 1: return disabledSections.count
    case 2: return 1
    default: return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0, 1:
      let cell = UITableViewCell()
      cell.selectionStyle = .none
      let sectionID = indexPath.section == 0 ? enabledSections[indexPath.row] : disabledSections[indexPath.row]
      switch sectionID {
      case -1:
        cell.textLabel?.text = "Pinned"
        cell.imageView?.image = UIImage(systemName: "pin.fill")
      case -2:
        cell.textLabel?.text = "Featured"
        cell.imageView?.image = UIImage(systemName: "star.fill")
      case -3:
        cell.textLabel?.text = "Upcoming"
        cell.imageView?.image = UIImage(systemName: "hourglass")
      default:
        let videoGameName: String
        if let name = preferredGames.first(where: { $0.id == sectionID })?.name {
          videoGameName = name
        } else if let name = discardedGames.first(where: { $0.id == sectionID })?.name {
          videoGameName = name
        } else {
          videoGameName = ""
        }
        cell.textLabel?.text = videoGameName
      }
      return cell
    case 2:
      let cell = UITableViewCell()
      cell.accessoryType = .disclosureIndicator
      cell.textLabel?.text = "Video Game Selection"
      cell.imageView?.image = UIImage(systemName: "gamecontroller.fill")
      return cell
    default: break
    }
    return UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section != 2
  }

  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section != 2
  }

  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    if sourceIndexPath.section == 0 && destinationIndexPath.section == 0 {
      let movedSection = enabledSections.remove(at: sourceIndexPath.row)
      enabledSections.insert(movedSection, at: destinationIndexPath.row)
    } else if sourceIndexPath.section == 0 && destinationIndexPath.section == 1 {
      let movedSection = enabledSections.remove(at: sourceIndexPath.row)
      disabledSections.insert(movedSection, at: destinationIndexPath.row)
      if movedSection != -1, movedSection != -2, movedSection != -3 {
        if let index = preferredGames.firstIndex(where: { $0.id == movedSection }) {
          discardedGames.insert(preferredGames.remove(at: index))
        }
      }
    } else if sourceIndexPath.section == 1 && destinationIndexPath.section == 0 {
      let movedSection = disabledSections.remove(at: sourceIndexPath.row)
      enabledSections.insert(movedSection, at: destinationIndexPath.row)
      if movedSection != -1, movedSection != -2, movedSection != -3 {
        if let index = discardedGames.firstIndex(where: { $0.id == movedSection }) {
          preferredGames.append(discardedGames.remove(at: index))
        }
      }
    } else if sourceIndexPath.section == 1 && destinationIndexPath.section == 1 {
      let movedSection = disabledSections.remove(at: sourceIndexPath.row)
      disabledSections.insert(movedSection, at: destinationIndexPath.row)
    }
    sectionsEdited = true
  }

  // MARK: - Table View Delegate

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "Enabled Sections"
    case 1: return "Disabled Sections"
    case 2: return "Video Game Selection"
    default: return nil
    }
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    switch section {
    case 1: return "Drag sections here to hide them from the main screen. Disabling a video game will also remove it from the Video Game Selection"
    default: return nil
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 2 else { return }
    let vc = VideoGamesVC(preferredGames)
    vc.applyChanges = { [weak self] in
      guard let self = self else { return }
      let preferredGames = $0

      // Remove any video games that were deselected in VideoGamesVC
      for section in self.enabledSections {
        guard section != -1, section != -2, section != -3 else { continue }
        if !preferredGames.contains(where: { $0.id == section }) {
          guard let index = self.enabledSections.firstIndex(of: section) else { continue }
          self.enabledSections.remove(at: index)
        }
      }
      // Add the new video games that were selected in VideoGamesVC
      for videoGame in preferredGames {
        // If the video game was previously disabled, re-enable it
        if let index = self.disabledSections.firstIndex(where: { $0 == videoGame.id }) {
          self.discardedGames.remove(videoGame)
          self.disabledSections.remove(at: index)
          self.enabledSections.append(videoGame.id)
        } else if !self.enabledSections.contains(videoGame.id) {
          self.enabledSections.append(videoGame.id)
        }
      }

      self.sectionsEdited = true
      self.preferredGames = preferredGames
      self.tableView.reloadData()
    }
    present(UINavigationController(rootViewController: vc), animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
    if proposedDestinationIndexPath.section == 2 {
      return IndexPath(row: sourceIndexPath.section == 0 ? disabledSections.count : disabledSections.count - 1, section: 1)
    }
    return proposedDestinationIndexPath
  }

  override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    return false
  }
}
