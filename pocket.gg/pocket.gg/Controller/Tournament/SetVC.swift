//
//  SetVC.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-06-21.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import UIKit

final class SetVC: UITableViewController {

  private let set: PhaseGroupSet
  private var games: [PhaseGroupSetGame]
  private var doneRequest = false
  private var requestSuccessful = true

  // MARK: Initialization

  init(_ set: PhaseGroupSet) {
    self.set = set
    games = []
    super.init(style: .insetGrouped)

    title = set.fullRoundText
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissVC))
    tableView.register(SubtitleCell.self, forCellReuseIdentifier: k.Identifiers.tournamentSetGameCell)
    loadPhaseGroupSetGames()
  }

  private func loadPhaseGroupSetGames() {
    doneRequest = false
    requestSuccessful = true
    guard let id = set.id else {
      doneRequest = true
      requestSuccessful = false
      tableView.reloadData()
      return
    }
    TournamentDetailsService.getPhaseGroupSetGames(id) { [weak self] (games) in
      guard let games = games else {
        self?.doneRequest = true
        self?.requestSuccessful = false
        self?.tableView.reloadData()
        return
      }

      self?.games = games

      self?.doneRequest = true
      self?.requestSuccessful = true
      self?.tableView.reloadData()
    }
  }

  // MARK: Actions

  @objc private func dismissVC() {
    dismiss(animated: true, completion: nil)
  }

  // MARK: Table View Data Source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section == 1 else { return 1 }
    guard doneRequest, requestSuccessful, !games.isEmpty else { return 1 }
    return games.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "Summary"
    case 1: return "Games"
    default: return nil
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = SetCell()
      cell.addSetInfo(set)
      cell.selectionStyle = .none
      return cell
    }
    guard doneRequest else { return LoadingCell() }
    guard requestSuccessful else { return UITableViewCell().setupDisabled(k.Message.errorLoadingGames) }
    guard !games.isEmpty else { return UITableViewCell().setupDisabled(k.Message.noGames) }
    guard let game = games[safe: indexPath.row] else { return UITableViewCell() }

    if let cell = tableView.dequeueReusableCell(withIdentifier: k.Identifiers.tournamentSetGameCell, for: indexPath) as? SubtitleCell {
      let text: String
      if let stageName = game.stageName {
        text = "Game \(indexPath.row + 1): " + stageName
      } else {
        text = "Game \(indexPath.row + 1)"
      }
      cell.textLabel?.text = text
      if let winnerID = game.winnerID {
        let winner = set.entrants?.first(where: {
          guard let id = $0.entrant?.id else { return false }
          return id == winnerID
        })?.entrant

        let attributedText = NSMutableAttributedString(string: "Winner: ")
        attributedText.append(SetUtilities.getAttributedEntrantText(winner, bold: false,
                                                                    size: cell.detailTextLabel?.font.pointSize ?? 10,
                                                                    teamNameLength: winner?.teamName?.count))
        cell.detailTextLabel?.attributedText = attributedText
      }

      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
}
